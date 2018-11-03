class Thermostat < ApplicationRecord
  has_secure_token :household_token
  has_many :readings
  has_one :sequence, foreign_key: :thermostats_id
  has_one :stat, foreign_key: :thermostats_id

  def save_init_data
    begin
      transaction do
        save
        Sequence.new(thermostats_id: id, number: 0).save
        Stat.new(thermostats_id: id).save
      end
    rescue StandardError
      return false
    end
    true
  end
end
