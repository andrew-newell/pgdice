# frozen_string_literal: true

require 'pg'
require 'open3'
require 'logger'
require 'pgslice'
require 'pgdice/version'
require 'pgdice/configuration'
require 'pgdice/pg_slice_manager'
require 'pgdice/partition_manager'
require 'pgdice/database_connection'
require 'pgdice/helpers/database_helper'
require 'pgdice/exceptions/pg_dice_error'
require 'pgdice/helpers/validation_helper'
require 'pgdice/exceptions/pg_slice_error'
require 'pgdice/exceptions/illegal_table_error'
require 'pgdice/exceptions/insufficient_future_tables_error'
