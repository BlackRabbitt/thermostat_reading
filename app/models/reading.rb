# frozen_string_literal: true

class Reading < ApplicationRecord
  belongs_to :thermostat, counter_cache: true
  # acts_as_sequenced column: :number, scope: :thermostat_id

  validates :temperature, :humidity, :battery_charge, numericality: true

  before_create :set_number
  after_create :update_thermostats!

  private

  def set_number
    self.number ||= ThermostatReading::Calculator.counter(thermostat.readings.maximum(:number))
  end

  def update_thermostats!
    thermostat.calculate_stat(temperature: temperature, humidity: humidity, battery_charge: battery_charge)
    thermostat.save!
  end
end
