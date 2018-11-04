require 'rails_helper'

RSpec.describe 'Stats', type: :request do
  extend ThermostatHelper
  stub_thermostat

  let(:headers) { { 'Authorization' => "Token #{@thermostat.household_token}" } }

  describe 'GET /stats' do
    before do
      @buffer = BufferManager.new(thermostat: @thermostat)
      @buffer.keep_stat(@reading)
      @buffer.number
    end

    it 'returns stats data' do
      get stats_path, headers: headers

      res = JSON.parse(response.body)['stat']
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(res['temperature_avg']).to eq(@reading.temperature)
      expect(res['temperature_max']).to eq(@reading.temperature)
      expect(res['temperature_min']).to eq(@reading.temperature)
      expect(res['humidity_avg']).to eq(@reading.humidity)
      expect(res['humidity_max']).to eq(@reading.humidity)
      expect(res['humidity_min']).to eq(@reading.humidity)
      expect(res['battery_charge_avg']).to eq(@reading.battery_charge)
      expect(res['battery_charge_max']).to eq(@reading.battery_charge)
      expect(res['battery_charge_min']).to eq(@reading.battery_charge)
    end
  end
end
