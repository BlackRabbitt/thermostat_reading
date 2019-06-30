# frozen_string_literal: true

module ThermostatReading
  class Calculator
    class << self
      # rubocop:disable Naming/UncommunicativeMethodParamName
      def sum(a, b)
        a.to_f + b.to_f
      end

      def counter(c)
        c.to_i + 1
      end

      def min(a, b)
        return b.to_f if a.to_f.zero?

        a.to_f < b.to_f ? a.to_f : b.to_f
      end

      def max(a, b)
        a.to_f > b.to_f ? a.to_f : b.to_f
      end

      def average(sum, count)
        sum.to_f / (count.to_i.nonzero? || 1)
      end
      # rubocop:enable Naming/UncommunicativeMethodParamName
    end
  end
end
