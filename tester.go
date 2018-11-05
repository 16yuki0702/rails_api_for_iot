package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"reflect"
	"sync"
	"time"
)

type reading struct {
	Temperature   float32 `json:"temperature"`
	Humidity      float32 `json:"humidity"`
	BatteryCharge float32 `json:"battery_charge"`
}

type readingLine struct {
	in  reading
	out reading
}

type stat struct {
	TemperatureAvg   float64 `json:"temperature_avg"`
	TemperatureMax   float32 `json:"temperature_max"`
	TemperatureMin   float32 `json:"temperature_min"`
	HumidityAvg      float64 `json:"humidity_avg"`
	HumidityMax      float32 `json:"humidity_max"`
	HumidityMin      float32 `json:"humidity_min"`
	BatteryChargeAvg float64 `json:"battery_charge_avg"`
	BatteryChargeMax float32 `json:"battery_charge_max"`
	BatteryChargeMin float32 `json:"battery_charge_min"`
}

type testParams struct {
	location     string
	readings     []readingLine
	expectedStat stat
}

func main() {
	var waitGroup sync.WaitGroup

	start := time.Now()

	for i := 0; i < len(params); i++ {
		waitGroup.Add(1)
		go func(i int) {
			defer waitGroup.Done()

			testAPI(params[i])

			fmt.Printf("done param%d\n", i)
		}(i)
	}
	waitGroup.Wait()

	end := time.Now()

	fmt.Printf("%v\n", (end.Sub(start)).Seconds())
}

func testAPI(param testParams) {
	token, err := postThermostat(param.location)
	if err != nil {
		fmt.Println(err)
		return
	}

	for _, v := range param.readings {
		number, err := postReading(token, v.in)
		if err != nil {
			fmt.Println(err)
			return
		}

		reading, err := getReading(token, number)
		if err != nil {
			fmt.Println(err)
			return
		}

		if !reflect.DeepEqual(reading, v.out) {
			fmt.Printf("(reading) got %v, expected %v\n", reading, v.out)
			return
		}
	}

	stat, err := getStat(token)
	if err != nil {
		fmt.Println(err)
		return
	}

	if !reflect.DeepEqual(stat, param.expectedStat) {
		fmt.Printf("(stat) got %v, expected %v\n", stat, param.expectedStat)
	}
}

func postThermostat(location string) (string, error) {
	reqParam := `{ "location": "` + location + `" }`

	req, err := http.NewRequest("POST", "http://localhost:3000/thermostats", bytes.NewBuffer([]byte(reqParam)))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")

	body, err := sendRequest(req)
	if err != nil {
		return "", err
	}

	respThermo := struct {
		Token  string `json:"token"`
		Status string `json:"status"`
	}{}

	if err := json.Unmarshal(body, &respThermo); err != nil {
		return "", err
	}

	return respThermo.Token, nil
}

func postReading(token string, r reading) (int, error) {
	reqParam := fmt.Sprintf("{ \"temperature\": \"%f\", \"humidity\": \"%f\", \"battery_charge\": \"%f\" }",
		r.Temperature, r.Humidity, r.BatteryCharge)

	req, err := http.NewRequest("POST", "http://localhost:3000/readings", bytes.NewBuffer([]byte(reqParam)))
	if err != nil {
		return 0, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Token "+token)

	body, err := sendRequest(req)
	if err != nil {
		return 0, err
	}

	respReading := struct {
		Number int `json:"number"`
	}{}

	if err := json.Unmarshal(body, &respReading); err != nil {
		return 0, err
	}

	return respReading.Number, nil
}

func getReading(token string, number int) (reading, error) {
	req, err := http.NewRequest("GET", fmt.Sprintf("http://localhost:3000/readings/%d", number), nil)
	if err != nil {
		return reading{}, err
	}
	req.Header.Set("Authorization", "Token "+token)

	body, err := sendRequest(req)
	if err != nil {
		return reading{}, err
	}

	respReading := struct {
		Reading reading `json:"reading"`
	}{}

	if err := json.Unmarshal(body, &respReading); err != nil {
		return reading{}, err
	}

	return respReading.Reading, nil
}

func getStat(token string) (stat, error) {
	req, err := http.NewRequest("GET", "http://localhost:3000/stats", nil)
	if err != nil {
		return stat{}, err
	}
	req.Header.Set("Authorization", "Token "+token)

	body, err := sendRequest(req)
	if err != nil {
		return stat{}, err
	}

	respStat := struct {
		Stat stat `json:"stat"`
	}{}

	if err := json.Unmarshal(body, &respStat); err != nil {
		return stat{}, err
	}

	return respStat.Stat, nil
}

func sendRequest(req *http.Request) ([]byte, error) {
	client := &http.Client{}

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return body, nil
}

var params = []testParams{param1, param2, param3}

var param1 = testParams{
	location: "1 1",
	readings: []readingLine{
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{28.0, 18.0, 8.0}, out: reading{28.0, 18.0, 8.0}},
		{in: reading{27.0, 17.0, 7.0}, out: reading{27.0, 17.0, 7.0}},
		{in: reading{26.0, 16.0, 6.0}, out: reading{26.0, 16.0, 6.0}},
		{in: reading{25.0, 15.0, 5.0}, out: reading{25.0, 15.0, 5.0}},
		{in: reading{24.0, 14.0, 4.0}, out: reading{24.0, 14.0, 4.0}},
		{in: reading{23.0, 13.0, 3.0}, out: reading{23.0, 13.0, 3.0}},
		{in: reading{22.0, 12.0, 2.0}, out: reading{22.0, 12.0, 2.0}},
		{in: reading{21.0, 11.0, 1.0}, out: reading{21.0, 11.0, 1.0}},
	},
	expectedStat: stat{
		25.5, 30.0, 21.0,
		15.5, 20.0, 11.0,
		5.5, 10.0, 1.0,
	},
}

var param2 = testParams{
	location: "2 2",
	readings: []readingLine{
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{28.0, 18.0, 8.0}, out: reading{28.0, 18.0, 8.0}},
		{in: reading{27.0, 17.0, 7.0}, out: reading{27.0, 17.0, 7.0}},
		{in: reading{26.0, 16.0, 6.0}, out: reading{26.0, 16.0, 6.0}},
	},
	expectedStat: stat{
		28.0, 30.0, 26.0,
		18.0, 20.0, 16.0,
		8.0, 10.0, 6.0,
	},
}

var param3 = testParams{
	location: "3 3",
	readings: []readingLine{
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
		{in: reading{30.0, 20.0, 10.0}, out: reading{30.0, 20.0, 10.0}},
		{in: reading{29.0, 19.0, 9.0}, out: reading{29.0, 19.0, 9.0}},
	},
	expectedStat: stat{
		29.5, 30.0, 29.0,
		19.5, 20.0, 19.0,
		9.5, 10.0, 9.0,
	},
}
