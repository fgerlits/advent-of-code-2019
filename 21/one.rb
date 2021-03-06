#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

PROGRAM = open('input').read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
INSTRUCTIONS = open(ARGV[0]).read.each_char.map(&:ord)
computer.add_inputs(INSTRUCTIONS)
computer.run
output = computer.read_and_clear_output
result = output.pop
puts output.map(&:chr).join
puts
puts result
