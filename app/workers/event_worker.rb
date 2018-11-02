class EventWorker
  include Sidekiq::Worker
  sidekiq_options queue: :event, retry: 5

  def perform(thermostat_id, number)
    thermostat = Thermostat.find(thermostat_id)
    buffer = BufferManager.new(thermostat: thermostat)
    reading = Reading.new.from_json(buffer.reading(number).to_json)

    reading.save
    thermostat.sequence.increment!('number', 1)
  end
end
