# frozen_string_literal: true

module PgDice
  class ParamSanitizer
    attr_reader :logger

    def initialize(logger:)
      @logger = logger
    end

    def call(params)
      params.transform_keys!(&:to_sym) if params.respond_to?(:transform_keys!)
      params
    end
  end
end
