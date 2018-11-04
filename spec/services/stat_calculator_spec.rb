require 'rails_helper'

RSpec.describe StatCalculator do
  extend ThermostatHelper
  stub_thermostat

  before do
    @buffer = BufferManager.new(thermostat: @thermostat)

    number = @buffer.number
    @buffer.keep_stat(Reading.new(number: number, temperature: 60.0, humidity: 40.0, battery_charge: 20.0, thermostats_id: @thermostat.id))

    @stat = StatCalculator.new(thermostat: @thermostat)
  end

  describe '#stat' do
    it 'is expected to return current stats' do
      res = @stat.stat

      expect(res[:temperature_avg]).to eq(45.0)
      expect(res[:temperature_max]).to eq(60.0)
      expect(res[:temperature_min]).to eq(30.0)
      expect(res[:humidity_avg]).to eq(30.0)
      expect(res[:humidity_max]).to eq(40.0)
      expect(res[:humidity_min]).to eq(20.0)
      expect(res[:battery_charge_avg]).to eq(15.0)
      expect(res[:battery_charge_max]).to eq(20.0)
      expect(res[:battery_charge_min]).to eq(10.0)
    end
  end
end
