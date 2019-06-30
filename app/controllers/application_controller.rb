# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { message: 'Record Not Found' }, status: 404
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { message: e.message }, status: 400
  end

  protected

  def authenticate_thermostat
    render(json: { message: 'Failed to authenticate thermostat' }, status: 401) && return unless thermostat
  end

  def thermostat
    @thermostat ||= Thermostat.find_by(household_token: request.headers['HouseholdToken'])
  end
end
