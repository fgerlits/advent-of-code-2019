#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

PROGRAM = open('input').read.split(',').map(&:to_i)
PROGRAM[0] = 2
computer = Computer.new(PROGRAM)
INSTRUCTIONS = open('program').read.each_char.map(&:ord)
computer.add_inputs(INSTRUCTIONS)
computer.run
output = computer.read_and_clear_output
result = output.pop
puts output.map(&:chr).join
puts
puts result
