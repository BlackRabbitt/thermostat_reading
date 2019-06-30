# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Thermostats', type: :request do
  let!(:thermostat) { create(:thermostat) }
  let!(:readings) { create_list(:reading, 5, thermostat_id: thermostat.id) }

  describe 'GET /thermostats' do
    context 'with unathorized household_token' do
      it 'returns unathorized' do
        get thermostats_path, headers: { 'HouseholdToken': Faker::Alphanumeric.alphanumeric(15) }
        expect(response).to have_http_status(401)
        expect(response.parsed_body['message']).to eq('Failed to authenticate thermostat')
      end
    end

    context 'with authorized household_token' do
      it 'returns the statistic for thermostat across all over the time.' do
        thermostat.reload

        get thermostats_path, headers: { 'HouseholdToken': thermostat.household_token }
        expect(response).to have_http_status(200)
        stat = response.parsed_body

        expect(stat['temperature']['average']).to eq(thermostat.temperature_sum / thermostat.readings_count)
        expect(stat['temperature']['maximum']).to eq(thermostat.temperature_max)
        expect(stat['temperature']['minimum']).to eq(thermostat.temperature_min)

        expect(stat['humidity']['average']).to eq(thermostat.humidity_sum / thermostat.readings_count)
        expect(stat['humidity']['maximum']).to eq(thermostat.humidity_max)
        expect(stat['humidity']['minimum']).to eq(thermostat.humidity_min)

        expect(stat['battery_charge']['average']).to eq(thermostat.battery_charge_sum / thermostat.readings_count)
        expect(stat['battery_charge']['maximum']).to eq(thermostat.battery_charge_max)
        expect(stat['battery_charge']['minimum']).to eq(thermostat.battery_charge_min)
      end
    end
  end
end
