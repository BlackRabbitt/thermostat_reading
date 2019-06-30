# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    temperature { Faker::Number.decimal(2, 2) }
    humidity { Faker::Number.decimal(2, 2) }
    battery_charge { Faker::Number.decimal(2, 2) }
  end
end
