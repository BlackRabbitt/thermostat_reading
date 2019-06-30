# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render status: 404
  end

  rescue_from ActionController::ParameterMissing do
    render status: 400
  end

  protected

  def authenticate_thermostat
    render(status: 401) && return unless thermostat
  end

  def thermostat
    @thermostat ||= Thermostat.find_by(household_token: request.headers['HouseholdToken'])
  end
end
