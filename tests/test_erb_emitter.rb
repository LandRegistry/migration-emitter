#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require 'tempfile'

class TestERBEmitter < MiniTest::Unit::TestCase
  def test_can_run_erb
    json = generate_nginx_config([
        'title_number: TEST12345'
        ])

    assert_match %r{server_name[^;]*\bwww.example.com\b}, server_declaration
  end
end
