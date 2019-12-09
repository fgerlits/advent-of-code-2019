#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

INPUT = ARGF.read.chomp.split(',').map{|w| w.to_i}

computer = Computer.new(INPUT.clone)
computer.add_inputs([1])
computer.run
puts computer.read_and_clear_output
