#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

PROGRAM = open(ARGV.shift).read.chomp.split(',').map{|w| w.to_i}
INPUTS = ARGV.map{|w| w.to_i}

computer = Computer.new(PROGRAM)
computer.add_inputs(INPUTS)
computer.run
puts computer.read_and_clear_output
