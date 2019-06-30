# frozen_string_literal: true

require 'rails_helper'

describe ThermostatReading::Calculator do
  let(:thermostat) { create(:thermostat) }
  let(:reading) { create(:reading, thermostat_id: thermostat.id) }

  let(:metrics) do
    {
      sum: Faker::Number.decimal(2, 2),
      min: Faker::Number.decimal(2, 2),
      max: Faker::Number.decimal(2, 2),
      count: Faker::Number.number
    }
  end

  it 'sum up two number' do
    expect(described_class.sum(metrics[:sum], reading.temperature)).to eq(metrics[:sum].to_f + reading.temperature)
    expect(described_class.sum(metrics[:sum], reading.humidity)).to eq(metrics[:sum].to_f + reading.humidity)
    expect(described_class.sum(metrics[:sum], reading.battery_charge))
      .to eq(metrics[:sum].to_f + reading.battery_charge)
  end

  it 'gives minimum of two number' do
    expect(described_class.min(metrics[:min], reading.temperature))
      .to eq(metrics[:min].to_f < reading.temperature ? metrics[:min].to_f : reading.temperature)

    expect(described_class.min(metrics[:min], reading.humidity))
      .to eq(metrics[:min].to_f < reading.humidity ? metrics[:min].to_f : reading.humidity)

    expect(described_class.min(metrics[:min], reading.battery_charge))
      .to eq(metrics[:min].to_f < reading.battery_charge ? metrics[:min].to_f : reading.battery_charge)
  end

  it 'gives maximum of two number' do
    expect(described_class.max(metrics[:max], reading.temperature))
      .to eq(metrics[:max].to_f > reading.temperature ? metrics[:max].to_f : reading.temperature)

    expect(described_class.max(metrics[:max], reading.humidity))
      .to eq(metrics[:max].to_f > reading.humidity ? metrics[:max].to_f : reading.humidity)

    expect(described_class.max(metrics[:max], reading.battery_charge))
      .to eq(metrics[:max].to_f > reading.battery_charge ? metrics[:max].to_f : reading.battery_charge)
  end

  it 'increase counter with 1' do
    expect(described_class.counter(metrics[:count])).to eq(metrics[:count].to_i + 1)
  end

  it 'gives average value' do
    expect(described_class.average(metrics[:sum], metrics[:count])).to eq(metrics[:sum].to_f / metrics[:count].to_i)
  end

  it 'gives sum instead of average if count is zero (divide by zero)' do
    expect(described_class.average(metrics[:sum], 0)).to eq(metrics[:sum].to_f)
  end
end
