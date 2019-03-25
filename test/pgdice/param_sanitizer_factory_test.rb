# frozen_string_literal: true

require 'test_helper'

class ParamSanitizerFactoryTest < Minitest::Test
  def test_create_param_sanitizer
    assert PgDice::ParamSanitizerFactory.new(PgDice.configuration).call
  end
end
