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
      @stat = Stat.new(thermostats_id: @thermostat.id,
                       temperature_total: 30.0,
                       temperature_max: 30.0,
                       temperature_min: 30.0,
                       humidity_total: 20.0,
                       humidity_max: 20.0,
                       humidity_min: 20.0,
                       battery_charge_total: 10.0,
                       battery_charge_max: 10.0,
                       battery_charge_min: 10.0)
      @stat.save
    end
  end
end
