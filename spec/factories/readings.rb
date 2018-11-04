FactoryBot.define do
  factory :reading do
    sequence(:number) { |n| n }
    temperature { 30.0 }
    humidity { 20.0 }
    battery_charge { 10.0 }
    sequence(:thermostats_id) { |n| n }
  end
end
