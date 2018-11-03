require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  before do
    @thermostat = build(:thermostat)
  end

  describe '#save_init_data' do
    it 'is valid with location' do
      expect(@thermostat.save_init_data).to eq(true)
      expect(Thermostat.count).to eq(1)
      expect(Sequence.count).to eq(1)
      expect(Stat.count).to eq(1)
    end

    it 'is invalid with nil location' do
      @thermostat.location = nil
      expect(@thermostat.save_init_data).to eq(false)
      expect(Thermostat.count).to eq(0)
      expect(Sequence.count).to eq(0)
      expect(Stat.count).to eq(0)
    end
  end
end
