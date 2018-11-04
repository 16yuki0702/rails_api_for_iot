require 'rails_helper'

RSpec.describe BufferManager do
  extend ThermostatHelper
  stub_thermostat

  before do
    @buffer = BufferManager.new(thermostat: @thermostat)
  end

  describe '#number' do
    it 'is expected to return number' do
      expect(@buffer.number).to eq(2)
    end
  end

  describe '#current_number' do
    it 'is expected to return number' do
      expect(@buffer.current_number).to eq('1')
    end
  end

  describe '#reading' do
    before do
      @buffer.set_reading(@reading)
    end

    it 'is expected to return saved reading' do
      res = @buffer.reading(@reading.number)

      expect(res['temperature']).to eq(@reading.temperature)
      expect(res['humidity']).to eq(@reading.humidity)
      expect(res['battery_charge']).to eq(@reading.battery_charge)
      expect(res['thermostats_id']).to eq(@reading.thermostats_id)
    end
  end

  describe '#keep_stat, total, max, min' do
    it 'is expected to return saved stats' do
      expect(@buffer.total(:temperature).to_i).to eq(@reading.temperature)
      expect(@buffer.max(:temperature).to_i).to eq(@reading.temperature)
      expect(@buffer.min(:temperature).to_i).to eq(@reading.temperature)
      expect(@buffer.total(:humidity).to_i).to eq(@reading.humidity)
      expect(@buffer.max(:humidity).to_i).to eq(@reading.humidity)
      expect(@buffer.min(:humidity).to_i).to eq(@reading.humidity)
      expect(@buffer.total(:battery_charge).to_i).to eq(@reading.battery_charge)
      expect(@buffer.max(:battery_charge).to_i).to eq(@reading.battery_charge)
      expect(@buffer.min(:battery_charge).to_i).to eq(@reading.battery_charge)
    end
  end
end
