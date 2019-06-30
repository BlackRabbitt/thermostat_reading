# frozen_string_literal: true

class Thermostat < ApplicationRecord
  has_secure_token :household_token
  has_many :readings

  validates :location, presence: true
  validates :location, length: { maximum: 500 }

  # calculates avg, min and max readings
  def calculate_stat(temperature: nil, humidity: nil, battery_charge: nil)
    self.temperature_sum = ThermostatReading::Calculator.sum(temperature_sum, temperature)
    self.temperature_max = ThermostatReading::Calculator.max(temperature_max, temperature)
    self.temperature_min = ThermostatReading::Calculator.min(temperature_min, temperature)

    self.humidity_sum = ThermostatReading::Calculator.sum(humidity_sum, humidity)
    self.humidity_max = ThermostatReading::Calculator.max(humidity_max, humidity)
    self.humidity_min = ThermostatReading::Calculator.min(humidity_min, humidity)

    self.battery_charge_sum = ThermostatReading::Calculator.sum(battery_charge_sum, battery_charge)
    self.battery_charge_max = ThermostatReading::Calculator.max(battery_charge_max, battery_charge)
    self.battery_charge_min = ThermostatReading::Calculator.min(battery_charge_min, battery_charge)
  end

  # getters
  def stat(metrics, key)
    thermostat_cache = ThermostatReading::Cache.new(household_token)

    if key == :average
      sum = thermostat_cache.fetch_stat("#{metrics}/sum") do
        send("#{metrics}_sum")
      end
      count = thermostat_cache.fetch_stat('readings/count') do
        readings_count
      end

      ThermostatReading::Calculator.average(sum, count)
    else
      thermostat_cache.fetch_stat("#{metrics}/#{key}") do
        send("#{metrics}_#{key}")
      end
    end
  end
end
