class Reading < ApplicationRecord
  belongs_to :thermostat, foreign_key: :thermostats_id
  THERMOSTAT_ATTRIBUTES = [:temperature, :humidity, :battery_charge]

  def as_json(options = {})
    options[:except] ||= [:id, :created_at, :updated_at]
    super(options)
  end
end
