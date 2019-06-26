# frozen_string_literal: true

class Reading < ApplicationRecord
  belongs_to :thermostat

  before_create do
    self.sequence_number = thermostat.next_sequence_number if sequence_number.blank?
  end
end
