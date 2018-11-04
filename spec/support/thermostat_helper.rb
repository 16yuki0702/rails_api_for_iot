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
      Sequence.new(thermostats_id: @thermostat.id, number: 0).save
      Stat.new(thermostats_id: @thermostat.id).save
    end
  end
end
