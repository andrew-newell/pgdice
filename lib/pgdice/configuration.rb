# frozen_string_literal: true

# Entry point for configuration
module PgDice
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end

  # Configuration class which holds all configurable values
  class Configuration
    attr_accessor :logger,
                  :database_url,
                  :pg_connection,
                  :database_connection,
                  :pg_slice_manager,
                  :partition_manager,
                  :approved_tables,
                  :validation_helper,
                  :preparation_helper,
                  :database_helper

    def initialize
      @logger = Logger.new('log/pgdice.log')
      @database_url = ''
      @approved_tables = []
      @database_connection = DatabaseConnection.new(self)
      @validation_helper = ValidationHelper.new(self)
      @pg_slice_manager = PgSliceManager.new(self)
      @partition_manager = PartitionManager.new(self)
      @preparation_helper = PreparationHelper.new(self)
      @database_helper = DatabaseHelper.new(self)
    end
  end
end