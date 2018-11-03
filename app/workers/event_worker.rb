class EventWorker
  include Sidekiq::Worker
  sidekiq_options queue: :event, retry: 5

  def perform(thermostat_id, number)
    @thermostat = Thermostat.find(thermostat_id)
    @buffer = BufferManager.new(thermostat: @thermostat)
    @reading = Reading.from_buffer(@buffer, number)
    @stat = Stat.from_buffer(@buffer)

    @reading.save
    @thermostat.sequence.increment!('number', 1)
    Stat.find_by(thermostats_id: thermostat_id).update_attributes(@stat.update_target)
  end
end
