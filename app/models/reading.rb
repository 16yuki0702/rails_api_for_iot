class Reading < ApplicationRecord
  belongs_to :thermostat, foreign_key: :thermostats_id
  THERMOSTAT_ATTRIBUTES = [:temperature, :humidity, :battery_charge]
end
