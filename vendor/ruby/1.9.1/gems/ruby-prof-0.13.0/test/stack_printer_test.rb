#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../test_helper', __FILE__)

# Test data
#     A
#    / \
#   B   C
#        \
#         B

class STPT
  def a
    100.times{b}
    300.times{c}
    c;c;c
  end

  def b
    sleep 0
  end

  def c
    5.times{b}
  end
end

class StackPrinterTest < Test::Unit::TestCase
  def setup
    # Need to use wall time for this test due to the sleep calls
    RubyProf::measure_mode = RubyProf::WALL_TIME
  end

  def test_stack_can_be_printed
    start_time = Time.now
    RubyProf.start
    5.times{STPT.new.a}
    result = RubyProf.stop
    end_time = Time.now
    expected_time = end_time - start_time

    file_contents = nil
    assert_nothing_raised { file_contents = print(result) }
    # TODO: why are thread ids negative on travis-ci.org (32 bit build maybe?)
    assert_match(/Thread: (-?\d+)(, Fiber: (-?\d+))? \(100\.00% ~ ([\.0-9]+)\)/, file_contents)
    actual_time = $4.to_f
    assert_in_delta(expected_time, actual_time, 0.5)
  end

  def test_method_elimination
    RubyProf.start
    5.times{STPT.new.a}
    result = RubyProf.stop
    assert_nothing_raised {
      # result.dump
      result.eliminate_methods!([/Integer#times/])
      # $stderr.puts "================================"
      # result.dump
      print(result)
    }
  end

  private
  def print(result)
    test = caller.first =~ /in `(.*)'/ ? $1 : "test"
    testfile_name = "#{RubyProf.tmpdir}/ruby_prof_#{test}.html"
    # puts "printing to #{testfile_name}"
    printer = RubyProf::CallStackPrinter.new(result)
    File.open(testfile_name, "w") {|f| printer.print(f, :threshold => 0, :min_percent => 0, :title => "ruby_prof #{test}")}
    system("open '#{testfile_name}'") if RUBY_PLATFORM =~ /darwin/ && ENV['SHOW_RUBY_PROF_PRINTER_OUTPUT']=="1"
    assert File.exist?(testfile_name), "#{testfile_name} does not exist"
    assert File.readable?(testfile_name), "#{testfile_name} is no readable"
    File.read(testfile_name)
  end
end