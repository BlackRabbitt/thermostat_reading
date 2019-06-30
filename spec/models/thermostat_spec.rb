# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  let(:thermostat) { create(:thermostat) }
  let!(:readings) { create_list(:reading, 5, thermostat_id: thermostat.id) }

  describe '#stat' do
    before { thermostat.reload }

    context 'temperature' do
      it 'returns average' do
        expect(thermostat.stat(:temperature, :average)).to eq(thermostat.temperature_sum / thermostat.readings_count)
      end

      it 'returns minimum' do
        expect(thermostat.stat(:temperature, :min)).to eq(thermostat.temperature_min)
      end

      it 'returns maximum' do
        expect(thermostat.stat(:temperature, :max)).to eq(thermostat.temperature_max)
      end
    end

    context 'humidity' do
      it 'returns average' do
        expect(thermostat.stat(:humidity, :average)).to eq(thermostat.humidity_sum / thermostat.readings_count)
      end

      it 'returns minimum' do
        expect(thermostat.stat(:humidity, :min)).to eq(thermostat.humidity_min)
      end

      it 'returns maximum' do
        expect(thermostat.stat(:humidity, :max)).to eq(thermostat.humidity_max)
      end
    end

    context 'battery_charge' do
      it 'returns average' do
        expect(thermostat.stat(:battery_charge, :average))
          .to eq(thermostat.battery_charge_sum / thermostat.readings_count)
      end

      it 'returns minimum' do
        expect(thermostat.stat(:battery_charge, :min)).to eq(thermostat.battery_charge_min)
      end

      it 'returns maximum' do
        expect(thermostat.stat(:battery_charge, :max)).to eq(thermostat.battery_charge_max)
      end
    end
  end
end
