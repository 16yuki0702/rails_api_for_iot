require 'rails_helper'

RSpec.describe EventWorker do
  extend ThermostatHelper
  stub_thermostat

  before do
    @buffer = BufferManager.new(thermostat: @thermostat)

    @number = @buffer.number
    @reading = Reading.new(number: @number, temperature: 60.0, humidity: 40.0, battery_charge: 20.0, thermostats_id: @thermostat.id)

    @buffer.set_reading(@reading)
    @buffer.keep_stat(@reading)
  end

  describe '#perform' do
    it 'is expected to store reading, stat to db' do
      EventWorker.new.perform(@thermostat.id, @number)

      @stat.reload
      expect(Reading.count).to eq(2)
      expect(@thermostat.sequence.reload.number).to eq(2)
      expect(@stat.temperature_total).to eq(60.0)
      expect(@stat.temperature_max).to eq(60.0)
      expect(@stat.temperature_min).to eq(0.0)
      expect(@stat.humidity_total).to eq(40.0)
      expect(@stat.humidity_max).to eq(40.0)
      expect(@stat.humidity_min).to eq(0.0)
      expect(@stat.battery_charge_total).to eq(20.0)
      expect(@stat.battery_charge_max).to eq(20.0)
      expect(@stat.battery_charge_min).to eq(0.0)
    end
  end

  describe '#perform_async' do
    it 'should be enqueue' do
      expect do
        EventWorker.perform_async(1, 1)
      end.to change(EventWorker.jobs, :size).by(1)
    end
  end
end
