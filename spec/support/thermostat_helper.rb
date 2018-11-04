module ThermostatHelper
  def stub_thermostat
    before do
      @thermostat = create(:thermostat)
      @reading = Reading.new(thermostats_id: @thermostat.id,
                             number: 1,
                             temperature: 30.0,
                             humidity: 20.0,
                             battery_charge: 10.0)
      @reading.save
      @sequence = Sequence.new(thermostats_id: @thermostat.id, number: 1)
      @sequence.save
      @stat = Stat.new(thermostats_id: @thermostat.id)
      @stat.save
    end
  end
end
