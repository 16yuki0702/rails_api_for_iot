require 'rails_helper'

RSpec.describe Reading, type: :model do
  extend ThermostatHelper
  stub_thermostat

  describe '#as_json' do
    it 'is not included id, created_at, and updated_at' do
      json = JSON.parse(@reading.to_json)
      expect(json).not_to have_key('id')
      expect(json).not_to have_key('created_at')
      expect(json).not_to have_key('updated_at')
    end
  end

  describe '#from_buffer' do
    before do
      @reading = build(:reading)
      @buffer = BufferManager.new(thermostat: @thermostat)
      @buffer.set_reading(@reading)
    end

    it 'is expected to get same data from buffer' do
      result = Reading.from_buffer(@buffer, @reading.number)
      expect(result.attributes).to eq(@reading.attributes)
    end
  end
end
