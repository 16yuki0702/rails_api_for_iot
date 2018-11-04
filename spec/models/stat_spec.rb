require 'rails_helper'

RSpec.describe Stat, type: :model do
  extend ThermostatHelper
  stub_thermostat

  describe '#update_target' do
    it 'is not included id, thermostats_id, created_at, and updated_at' do
      target = @stat.update_target
      expect(target).not_to have_key('id')
      expect(target).not_to have_key('thermostats_id')
      expect(target).not_to have_key('created_at')
      expect(target).not_to have_key('updated_at')
    end
  end

  describe '#from_buffer' do
    before do
      @buffer = BufferManager.new(thermostat: @thermostat)
      @buffer.keep_stat(@reading)
      @buffer.number
    end

    it 'is expected to get same data from buffer' do
      res = Stat.from_buffer(@buffer)
      expect(res['temperature_total']).to eq(@reading.temperature)
      expect(res['temperature_max']).to eq(@reading.temperature)
      expect(res['temperature_min']).to eq(@reading.temperature)
      expect(res['humidity_total']).to eq(@reading.humidity)
      expect(res['humidity_max']).to eq(@reading.humidity)
      expect(res['humidity_min']).to eq(@reading.humidity)
      expect(res['battery_charge_total']).to eq(@reading.battery_charge)
      expect(res['battery_charge_max']).to eq(@reading.battery_charge)
      expect(res['battery_charge_min']).to eq(@reading.battery_charge)
    end
  end
end
