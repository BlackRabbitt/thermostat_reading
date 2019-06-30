# frozen_string_literal: true

require 'rails_helper'

describe CreateReadingJob, type: :job do
  let(:thermostat) { create(:thermostat) }

  subject(:job) { described_class.perform_later(reading_params) }
  let(:reading_params) do
    {
      temperature: Faker::Number.decimal(2, 2),
      humidity: Faker::Number.decimal(2, 2),
      battery_charge: Faker::Number.decimal(2, 2),
      thermostat_id: thermostat.id,
      number: Faker::Number.number
    }
  end

  it 'queues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect { job }.to have_enqueued_job(described_class)
      .with(reading_params)
      .on_queue('default')
  end

  it 'creates reading' do
    described_class.perform_now(reading_params)
    expect(thermostat.readings.count).to eq(1)
  end
end
