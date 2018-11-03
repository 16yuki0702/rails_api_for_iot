class Stat < ApplicationRecord
  belongs_to :thermostat, foreign_key: :thermostats_id

  def update_target
    attributes.except('id', 'thermostats_id', 'created_at', 'updated_at')
  end

  def self.from_buffer(buffer)
    s = Stat.new
    Reading::THERMOSTAT_ATTRIBUTES.each do |k|
      s["#{k}_total"] = buffer.total(k)
      s["#{k}_max"]   = buffer.max(k)
      s["#{k}_min"]   = buffer.min(k)
    end
    s
  end
end
