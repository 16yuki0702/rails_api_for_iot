class Reading < ApplicationRecord
  belongs_to :thermostat, foreign_key: :thermostats_id
  THERMOSTAT_ATTRIBUTES = %i[temperature humidity battery_charge].freeze

  def as_json(options = {})
    options[:except] ||= %i[id created_at updated_at]
    super(options)
  end

  class << self
    def from_buffer(buffer, number)
      Reading.new.from_json(buffer.reading(number).to_json)
    end
  end
end
