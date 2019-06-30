# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Readings', type: :request do
  let!(:thermostat) { create(:thermostat) }

  describe 'POST /readings' do
    let(:params) do
      {
        reading: {
          temperature: Faker::Number.decimal(2, 2),
          humidity: Faker::Number.decimal(2, 2),
          battery_charge: Faker::Number.decimal(2, 2)
        }
      }
    end
    context 'with unathorized household_token' do
      it 'returns unathorized' do
        post readings_path, params: params, headers: { 'HouseholdToken': Faker::Alphanumeric.alphanumeric(15) }
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorized household_token' do
      it 'creates readings for thermostat' do
        number = thermostat.readings.maximum(:number).to_i + 1

        post readings_path, params: params, headers: { 'HouseholdToken': thermostat.household_token }
        expect(response).to have_http_status(200)
        expect(response.parsed_body['number']).to eq(number)
      end
    end

    context 'with invalid reading' do
      it 'returns error object with 422 status' do
        post readings_path,
             params: { reading: { temperature: 'String' } },
             headers: { 'HouseholdToken': thermostat.household_token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['temperature'][0]).to eq('is not a number')
        expect(response.parsed_body['humidity'][0]).to eq('is not a number')
      end
    end

    context 'with invalid params' do
      it 'returns 400 Bad Request status' do
        post readings_path, params: {}, headers: { 'HouseholdToken': thermostat.household_token }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /readings/:number' do
    let!(:reading) { create(:reading, thermostat_id: thermostat.id) }

    context 'with unathorized household_token' do
      it 'returns unathorized' do
        get reading_path(reading.number), headers: { 'HouseholdToken': Faker::Alphanumeric.alphanumeric(15) }
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorized household_token' do
      it 'returns reading from number' do
        get reading_path(reading.number), headers: { 'HouseholdToken': thermostat.household_token }

        expect(response).to have_http_status(200)

        expect(response.parsed_body['number']).to eq(reading.number)
        expect(response.parsed_body['temperature']).to eq(reading.temperature)
      end
    end

    context 'if reading is not present' do
      it 'returns 404 not found status' do
        get reading_path(1000), headers: { 'HouseholdToken': thermostat.household_token }
        expect(response).to have_http_status(404)
      end
    end
  end
end
