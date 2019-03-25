# frozen_string_literal: true

module PgDice
  class ParamSanitizerFactory
    extend Forwardable

    def_delegators :@configuration, :logger

    def initialize(configuration)
      @configuration = configuration
    end

    def call
      PgDice::ParamSanitizer.new(logger: logger)
    end
  end
end
