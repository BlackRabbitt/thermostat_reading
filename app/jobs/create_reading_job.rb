# frozen_string_literal: true

class CreateReadingJob < ApplicationJob
  queue_as :default

  def perform(reading_params)
    Reading.create(reading_params)
  end
end
