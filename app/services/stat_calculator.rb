class StatCalculator
  def initialize(thermostat:)
    @thermostat = thermostat
    @buffer = BufferManager.new(thermostat: @thermostat)
    @stat = Stat.from_buffer(@buffer)
  end

  def stat
    count = @buffer.current_number.to_i

    temperature_avg    = @stat.temperature_total    / count
    humidity_avg       = @stat.humidity_total       / count
    battery_charge_avg = @stat.battery_charge_total / count

    {
      :temperature_avg    => temperature_avg,
      :temperature_max    => @stat.temperature_max,
      :temperature_min    => @stat.temperature_min,
      :humidity_avg       => humidity_avg,
      :humidity_max       => @stat.humidity_max,
      :humidity_min       => @stat.humidity_min,
      :battery_charge_avg => battery_charge_avg,
      :battery_charge_max => @stat.battery_charge_max,
      :battery_charge_min => @stat.battery_charge_min,
    }
  end
end
