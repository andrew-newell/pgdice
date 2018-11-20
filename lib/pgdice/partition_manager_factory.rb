# frozen_string_literal: true

# Entry point for PartitionManager
module PgDice
  #  PartitionManagerFactory is a class used to build PartitionManagers
  class PartitionManagerFactory
    extend Forwardable

    def_delegators :@configuration, :batch_size, :approved_tables, :database_connection


    def initialize(configuration = PgDice::Configuration.new, opts = {})
      @configuration = configuration
      @validation_factory = opts[:validation_factory] ||= PgDice::ValidationFactory.new(@configuration)
      @pg_slice_factory = opts[:pg_slice_factory] ||= pg_slice_factory
      @partition_lister_factory = opts[:partition_lister_factory] ||= partition_lister_factory
      @partition_dropper_factory = opts[:partition_dropper_factory] ||= partition_dropper_factory
      @partition_adder_factory = opts[:partition_adder_factory] ||= partition_adder_factory
    end

    def call
      PgDice::PartitionManager.new(logger: logger,
                                   batch_size: batch_size,
                                   validation: @validation_factory.call,
                                   partition_lister: @partition_lister_factory.call,
                                   partition_dropper: @partition_dropper_factory.call,
                                   partition_adder: @partition_adder_factory.call)


    end

    def validation_factory
      proc do
        PgDice::Validation.new(logger: logger,
                               database_connection: database_connection,
                               approved_tables: approved_tables)
      end
    end

    def partition_adder_factory
      pg_slice_factory
    end

    def partition_lister_factory
      proc { PgDice::PartitionLister.new(database_connection: database_connection) }
    end

    def partition_dropper_factory
      proc { PgDice::TableDropper.new(logger: logger, database_connection: database_connection) }
    end

    def pg_slice_factory
      proc { PgDice::PgSliceManager.new(logger: logger, database_url: database_url, dry_run: dry_run) }
    end
  end
end
