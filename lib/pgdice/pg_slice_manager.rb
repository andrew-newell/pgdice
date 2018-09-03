# frozen_string_literal: true

# PgSliceManager is a wrapper around PgSlice
class PgSliceManager
  def initialize(configuration = Configuration.new)
    @configuration = configuration
  end

  def prep(params = {})
    table_name = params.fetch(:table_name)
    column_name = params.fetch(:column_name)
    period = params.fetch(:period)
    run_pgslice("prep #{table_name} #{column_name} #{period}")
  end

  def fill(params = {})
    table_name = params.fetch(:table_name)
    swapped = params.fetch(:swapped, '')
    swapped = '--swapped' if swapped.to_s.casecmp('true').zero?

    run_pgslice("fill #{table_name} #{swapped}")
  end

  def analyze(params = {})
    table_name = params.fetch(:table_name)
    swapped = params.fetch(:swapped, '')
    swapped = '--swapped' if swapped.to_s.casecmp('true').zero?

    run_pgslice("analyze #{table_name} #{swapped}")
  end

  def swap(params = {})
    table_name = params.fetch(:table_name)
    run_pgslice("swap #{table_name}")
  end

  def add_partitions(params = {})
    table_name = params.fetch(:table_name)
    future_tables = params.fetch(:future, nil)
    future_tables = "--future #{Integer(future_tables)}" if future_tables

    past_tables = params.fetch(:past, nil)
    past_tables = "--past #{Integer(past_tables)}" if past_tables

    intermediate = params.fetch(:intermediate, nil)
    intermediate = '--intermediate' if intermediate.to_s.casecmp('true').zero?

    run_pgslice("add_partitions #{table_name} #{intermediate} #{future_tables} #{past_tables}")
  end

  def unprep!(params = {})
    table_name = params.fetch(:table_name)

    run_pgslice("unprep #{table_name}")
  end

  def unswap!(params = {})
    table_name = params.fetch(:table_name)

    run_pgslice("unswap #{table_name}")
  end

  def unprep(params = {})
    table_name = params.fetch(:table_name)

    run_pgslice("unprep #{table_name}")
  rescue PgSliceError => error
    logger.error { "Rescued PgSliceError: #{error}" }
    false
  end

  def unswap(params = {})
    table_name = params.fetch(:table_name)

    run_pgslice("unswap #{table_name}")
  rescue PgSliceError => error
    logger.error { "Rescued PgSliceError: #{error}" }
    false
  end

  private

  def logger
    @configuration.logger
  end

  def run_pgslice(argument_string)
    parameters = build_pg_slice_command(argument_string)

    stdout, stderr, status = Open3.capture3(parameters)
    log_result(stdout, stderr, status)

    if status.exitstatus.to_i.positive?
      raise PgSliceError, "pgslice with arguments: '#{argument_string}' failed with status: '#{status.exitstatus}' "\
"STDOUT: '#{stdout}' STDERR: '#{stderr}'"
    end
    true
  end

  def build_pg_slice_command(argument_string)
    argument_string = argument_string.strip
    logger.info { "Running pgslice command: '#{argument_string}'" }
    $stdout.flush
    $stderr.flush
    "pgslice #{argument_string} --url #{@configuration.database_url}"
  end

  def log_result(stdout, stderr, status)
    logger.debug { "pgslice STDERR: #{stderr}" } if stderr
    logger.debug { "pgslice STDOUT: #{stdout}" } if stdout
    logger.debug { "pgslice exit status: #{status.exitstatus}" } if status
  end
end