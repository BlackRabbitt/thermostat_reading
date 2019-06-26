# frozen_string_literal: true

class Thermostat < ApplicationRecord
  has_secure_token :household_token

  has_many :readings

  # returns sequence number for readings.
  # returns 1 if thermostat.readings is empty
  def next_sequence_number
    return readings.size + 1
  end
end
