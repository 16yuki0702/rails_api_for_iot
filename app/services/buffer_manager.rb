class BufferManager
  DEFAULT_TIMEOUT = 60 * 60 * 24 # 1 day

  def initialize(thermostat:)
    @thermostat = thermostat

    # if buffer data has gone away
    if DataBuffer.get(sequence_key).nil?
      @thermostat.sequence.with_lock do
        DataBuffer.set(sequence_key, @thermostat.sequence.number)
      end

      s = @thermostat.stat
      s.with_lock do
        Reading::THERMOSTAT_ATTRIBUTES.each do |k|
          set_total(k, s["#{k}_total"])
          set_max(k, s["#{k}_max"])
          set_min(k, s["#{k}_min"])
        end
      end
    end
  end

  def number
    DataBuffer.incr(sequence_key)
  end

  def current_number
    DataBuffer.get(sequence_key)
  end

  def set_reading(reading)
    set_with_timeout(reading_key(reading.number), reading.to_json)
  end

  def reading(number)
    cache = DataBuffer.get(reading_key(number))
    cache.present? ? JSON.parse(cache) : nil
  end

  def total(k)
    DataBuffer.get(stat_total_key(k))
  end

  def max(k)
    DataBuffer.get(stat_max_key(k))
  end

  def min(k)
    DataBuffer.get(stat_min_key(k))
  end

  def keep_stat(reading)
    # each thermostat does not call this method at the same time.
    # because each thermostat has its own key that never duplicated
    # and call it at regular interval.
    # so this method doesn't need locking.
    Reading::THERMOSTAT_ATTRIBUTES.each do |k|
      v = reading[k]

      DataBuffer.incrbyfloat(stat_total_key(k), v)

      max = DataBuffer.get(stat_max_key(k))
      DataBuffer.set(stat_max_key(k), v) if max.nil? || max.to_f < v

      min = DataBuffer.get(stat_min_key(k))
      DataBuffer.set(stat_min_key(k), v) if min.nil? || min.to_f > v || reading.number == 1
    end
  end

  private

  def sequence_key
    "sequence_#{@thermostat.id}"
  end

  def reading_key(number)
    "reading_#{@thermostat.id}_#{number}"
  end

  def stat_total_key(kind)
    "stat_#{@thermostat.id}_total_#{kind}"
  end

  def stat_max_key(kind)
    "stat_#{@thermostat.id}_max_#{kind}"
  end

  def stat_min_key(kind)
    "stat_#{@thermostat.id}_min_#{kind}"
  end

  def set_total(k, v)
    DataBuffer.set(stat_total_key(k), v)
  end

  def set_max(k, v)
    DataBuffer.set(stat_max_key(k), v)
  end

  def set_min(k, v)
    DataBuffer.set(stat_min_key(k), v)
  end

  def set_with_timeout(key, value)
    DataBuffer.multi do
      DataBuffer.set(key, value)
      DataBuffer.expire(key, DEFAULT_TIMEOUT)
    end
  end
end
