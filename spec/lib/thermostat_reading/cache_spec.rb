# frozen_string_literal: true

require 'rails_helper'

describe ThermostatReading::Cache do
  let(:cache) { Rails.cache }

  let(:thermostat) { create(:thermostat) }
  let(:thermostat_cache) { described_class.new(thermostat.household_token) }
  let!(:readings) { create_list(:reading, 5, thermostat_id: thermostat.id) }

  context '#cache!(reading)' do
    let(:reading_params) do
      {
        temperature: Faker::Number.decimal(2, 2),
        humidity: Faker::Number.decimal(2, 2),
        battery_charge: Faker::Number.decimal(2, 2),
        number: thermostat.readings.maximum(:number).to_i + 1
      }
    end

    before do
      thermostat.reload
      thermostat_cache.cache!(reading_params) { |key| thermostat.send(key) }
    end

    it 'set :reading attribute' do
      expect(thermostat_cache.reading[:temperature]).to eq(reading_params[:temperature])
      expect(thermostat_cache.reading[:humidity]).to eq(reading_params[:humidity])
      expect(thermostat_cache.reading[:battery_charge]).to eq(reading_params[:battery_charge])
      expect(thermostat_cache.reading[:number]).to eq(reading_params[:number])
    end

    it 'cache_reading!' do
      key = "#{thermostat.household_token}/readings/#{reading_params[:number]}"
      reading = cache.read(key)
      expect(reading[:temperature]).to eq(reading_params[:temperature])
      expect(reading[:humidity]).to eq(reading_params[:humidity])
      expect(reading[:battery_charge]).to eq(reading_params[:battery_charge])
      expect(reading[:number]).to eq(reading_params[:number])
    end

    it 'cache_last_used_number!' do
      key = "#{thermostat.household_token}/readings/last_used_number"
      expect(cache.read(key)).to eq(reading_params[:number])
    end

    it 'cache_readings_count!' do
      key = "#{thermostat.household_token}/readings/count"
      expect(cache.read(key)).to eq(reading_params[:number])
    end

    context 'cache_metrics!' do
      context 'temperature' do
        let(:key_prefix) { "#{thermostat.household_token}/temperature" }
        it 'cache temperature sum' do
          sum = ThermostatReading::Calculator.sum(thermostat.temperature_sum, reading_params[:temperature])
          expect(cache.read(key_prefix + '/sum')).to eq(sum)
        end

        it 'cache temperature min' do
          min = ThermostatReading::Calculator.min(thermostat.temperature_min, reading_params[:temperature])
          expect(cache.read(key_prefix + '/min')).to eq(min)
        end

        it 'cache temperature max' do
          max = ThermostatReading::Calculator.max(thermostat.temperature_max, reading_params[:temperature])
          expect(cache.read(key_prefix + '/max')).to eq(max)
        end
      end

      context 'humidity' do
        let(:key_prefix) { "#{thermostat.household_token}/humidity" }
        it 'cache humidity sum' do
          sum = ThermostatReading::Calculator.sum(thermostat.humidity_sum, reading_params[:humidity])
          expect(cache.read(key_prefix + '/sum')).to eq(sum)
        end

        it 'cache humidity min' do
          min = ThermostatReading::Calculator.min(thermostat.humidity_min, reading_params[:humidity])
          expect(cache.read(key_prefix + '/min')).to eq(min)
        end

        it 'cache humidity max' do
          max = ThermostatReading::Calculator.max(thermostat.humidity_max, reading_params[:humidity])
          expect(cache.read(key_prefix + '/max')).to eq(max)
        end
      end

      context 'battery_charge' do
        let(:key_prefix) { "#{thermostat.household_token}/battery_charge" }
        it 'cache battery_charge sum' do
          sum = ThermostatReading::Calculator.sum(thermostat.battery_charge_sum, reading_params[:battery_charge])
          expect(cache.read(key_prefix + '/sum')).to eq(sum)
        end

        it 'cache battery_charge min' do
          min = ThermostatReading::Calculator.min(thermostat.battery_charge_min, reading_params[:battery_charge])
          expect(cache.read(key_prefix + '/min')).to eq(min)
        end

        it 'cache battery_charge max' do
          max = ThermostatReading::Calculator.max(thermostat.battery_charge_max, reading_params[:battery_charge])
          expect(cache.read(key_prefix + '/max')).to eq(max)
        end
      end
    end
  end
end
