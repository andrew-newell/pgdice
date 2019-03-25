# frozen_string_literal: true

require 'test_helper'

class ParamSanitizerTest < Minitest::Test
  def test_converts_string_keys
    assert_equal({ key: 'value' }, PgDice::ParamSanitizer.new(logger: logger).call('key' => 'value'))
  end

  def test_handles_nil
    assert_nil PgDice::ParamSanitizer.new(logger: logger).call(nil)
  end
end
