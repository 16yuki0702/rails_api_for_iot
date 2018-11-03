FactoryBot.define do
  factory :thermostat do
    sequence(:location) { |n| "POINT(#{n} #{n})" }
  end
end
