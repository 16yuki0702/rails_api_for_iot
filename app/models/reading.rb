class Reading < ApplicationRecord
  belongs_to :thermostat, foreign_key: :thermostats_id
end
