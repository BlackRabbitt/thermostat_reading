# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  thermostat = Thermostat.create(location: Faker::Address.full_address)
  7.times do
    thermostat.readings.create(temperature: Faker::Number.decimal(2, 2),
                               humidity: Faker::Number.decimal(2, 2),
                               battery_charge: Faker::Number.decimal(2, 2))
  end
end
