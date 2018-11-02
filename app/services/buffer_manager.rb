class BufferManager
  DEFAULT_TIMEOUT = 60 * 60 * 24 # 1 day

  def initialize(thermostat:)
    @thermostat = thermostat

    # if redis data was gone away
    if DataBuffer.get(sequence_key).nil?
      @thermostat.sequence.with_lock do
        DataBuffer.set(sequence_key, @thermostat.sequence.number)
      end
    end
  end

  def number
    DataBuffer.incr(sequence_key)
  end

  def set_reading(reading)
    DataBuffer.multi do
      key = reading_key(reading.number)
      DataBuffer.set(key, reading.to_json)
      DataBuffer.expire(key, DEFAULT_TIMEOUT)
    end
  end

  def reading(number)
    cache = DataBuffer.get(reading_key(number))
    cache.present? ? JSON.parse(cache) : nil
  end

  private

    def sequence_key
      "sequence_#{@thermostat.id}"
    end

    def reading_key(number)
      "reading_#{@thermostat.id}_#{number}"
    end
end
