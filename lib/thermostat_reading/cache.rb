# frozen_string_literal: true

module ThermostatReading
  class Cache
    attr_reader :reading

    def initialize(household_token)
      @household_token = household_token
    end

    # cache! expects a block that returns db_value for key if key is not found in cache store.
    def cache!(reading)
      @reading = reading.as_json.with_indifferent_access

      cache_reading!
      cache_last_used_number!

      cache_readings_count! { |key| yield(key) }

      cache_metrics!(:temperature) { |key| yield(key) }
      cache_metrics!(:humidity) { |key| yield(key) }
      cache_metrics!(:battery_charge) { |key| yield(key) }
    end

    def cache_readings_count!
      key = "#{@household_token}/readings/count"

      # fetch readings_count from cache if not present load from db through callback
      readings_count = cache.fetch(key) { yield('readings_count') }
      counter = ThermostatReading::Calculator.counter(readings_count)
      cache.write(key, counter)
    end

    def fetch_reading(number)
      key = "#{@household_token}/readings/#{number}"
      cache.fetch(key) { yield }
    end

    def fetch_last_used_number
      cache.fetch("#{@household_token}/readings/last_used_number") { yield }
    end

    # metrics: "temperature/sum"
    def fetch_stat(metric_param)
      cache.fetch("#{@household_token}/#{metric_param}") { yield }
    end

    protected

    def cache_reading!
      key = "#{@household_token}/readings/#{@reading[:number]}"
      cache.write(key, @reading)
    end

    def cache_last_used_number!
      key = "#{@household_token}/readings/last_used_number"
      cache.write(key, @reading[:number])
    end

    def cache_metrics!(metrics_key)
      key_prefix = "#{@household_token}/#{metrics_key}"

      old_sum = fetch_stat("#{key_prefix}/sum") { yield("#{metrics_key}_sum") }
      sum = ThermostatReading::Calculator.sum(old_sum, @reading[metrics_key])
      cache.write("#{key_prefix}/sum", sum)

      old_min = fetch_stat("#{key_prefix}/min") { yield("#{metrics_key}_min") }
      min = ThermostatReading::Calculator.min(old_min, @reading[metrics_key])
      cache.write("#{key_prefix}/min", min)

      old_max = fetch_stat("#{key_prefix}/max") { yield("#{metrics_key}_max") }
      max = ThermostatReading::Calculator.max(old_max, @reading[metrics_key])
      cache.write("#{key_prefix}/max", max)
    end

    private

    def cache
      @cache ||= Rails.cache
    end
  end
end
