class Thermostat < ApplicationRecord
  has_secure_token :household_token
  has_many :readings
  has_one :sequence, foreign_key: :thermostats_id

  def save_init_data
    begin
      self.transaction do
        self.save
        Sequence.new(thermostats_id: self.id, number: 0).save
      end
    rescue
      return false
    end
    true
  end
end
