class Thermostat < ApplicationRecord
  has_secure_token :household_token
end
