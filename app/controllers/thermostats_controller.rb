# frozen_string_literal: true

class ThermostatsController < ApplicationController
  before_action :authenticate_thermostat

  def index
    results = {
      temperature: {
        average: thermostat.stat(:temperature, :average),
        minimum: thermostat.stat(:temperature, :min),
        maximum: thermostat.stat(:temperature, :max)
      },
      humidity: {
        average: thermostat.stat(:humidity, :average),
        minimum: thermostat.stat(:humidity, :min),
        maximum: thermostat.stat(:humidity, :max)
      },
      battery_charge: {
        average: thermostat.stat(:battery_charge, :average),
        minimum: thermostat.stat(:battery_charge, :min),
        maximum: thermostat.stat(:battery_charge, :max)
      }
    }

    render json: results, status: 200
  end
end
