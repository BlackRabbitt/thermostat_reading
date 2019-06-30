# frozen_string_literal: true

class ReadingsController < ApplicationController
  before_action :authenticate_thermostat
  before_action :set_reading, only: :show

  def show
    render json: @reading, status: 200
  end

  def create
    reading = thermostat.readings.build(reading_params)
    if reading.valid?
      thermostat_cache = ThermostatReading::Cache.new(thermostat.household_token)

      last_used_number = thermostat_cache.fetch_last_used_number do
        # number is incremental, so maximum will be the last used number
        thermostat.readings.maximum(:number)
      end
      number = ThermostatReading::Calculator.counter(last_used_number)

      thermostat_cache.cache!(reading_params.merge(number: number)) do |key|
        # if any key is missing from redis, pull it from db.
        thermostat.send(key)
      end

      CreateReadingJob.perform_later(thermostat_cache.reading.merge(thermostat_id: thermostat.id))
      render json: { number: number }, status: 200
    else
      render json: reading.errors, status: 422
    end
  end

  private

  def reading_params
    params.require(:reading).permit(:temperature, :humidity, :battery_charge)
  end

  def set_reading
    thermostat_cache = ThermostatReading::Cache.new(thermostat.household_token)
    @reading = thermostat_cache.fetch_reading(params[:number]) do
      thermostat.readings.find_by!(number: params[:number])
    end
  end
end
