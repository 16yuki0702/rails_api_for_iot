require 'rails_helper'

RSpec.describe 'Readings', type: :request do
  extend ThermostatHelper
  stub_thermostat

  let(:headers) { { 'Authorization' => "Token #{@thermostat.household_token}" } }

  describe 'GET /readings/:number' do
    it 'returns specified reading' do
      get "/readings/#{@reading.number}", headers: headers

      res = JSON.parse(response.body)['reading']
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(res['number']).to eq(@reading.number)
      expect(res['temperature']).to eq(@reading.temperature)
      expect(res['humidity']).to eq(@reading.humidity)
      expect(res['battery_charge']).to eq(@reading.battery_charge)
    end
  end

  describe 'POST /readings' do
    let(:params) { { reading: { temperature: '30.0', humidity: '20.0', battery_charge: '10.0' } } }

    it "returns created reading's number" do
      post '/readings', params: params, headers: headers

      res = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(res['number']).not_to eq(nil)
    end
  end
end
