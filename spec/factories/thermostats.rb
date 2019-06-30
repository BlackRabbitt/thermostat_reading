# frozen_string_literal: true

FactoryBot.define do
  factory :thermostat do
    location { Faker::Address.full_address }
  end
end
