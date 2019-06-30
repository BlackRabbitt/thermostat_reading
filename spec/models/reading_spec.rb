# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:thermostat) { create(:thermostat) }
  let!(:readings) { create_list(:reading, 5, thermostat_id: thermostat.id) }

  describe '#set_number' do
    it 'set number to 1 if thermostat.readings_count = 0' do
      reading = create(:reading, thermostat: create(:thermostat))
      expect(reading.number).to eq(1)
    end

    context 'thermostat with multiple readings' do
      it 'set number to max(:number)+1' do
        thermostat.reload

        new_reading = FactoryBot.create(:reading, thermostat_id: thermostat.id)
        expect(new_reading.number).to eq(readings.map(&:number).max + 1)
      end
    end
  end

  describe '#update_thermostat' do
    it 'update thermostat metrics fields for each readings' do
      thermostat.reload
      expect(thermostat.temperature_sum).to eq(thermostat.readings.sum(:temperature))
      expect(thermostat.humidity_sum).to eq(thermostat.readings.sum(:humidity))
      expect(thermostat.battery_charge_sum).to eq(thermostat.readings.sum(:battery_charge))

      expect(thermostat.temperature_max).to eq(thermostat.readings.maximum(:temperature))
      expect(thermostat.humidity_max).to eq(thermostat.readings.maximum(:humidity))
      expect(thermostat.battery_charge_max).to eq(thermostat.readings.maximum(:battery_charge))

      expect(thermostat.temperature_min).to eq(thermostat.readings.minimum(:temperature))
      expect(thermostat.humidity_min).to eq(thermostat.readings.minimum(:humidity))
      expect(thermostat.battery_charge_min).to eq(thermostat.readings.minimum(:battery_charge))
    end
  end
end
