#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

SIZE_X, SIZE_Y = 50, 50

PROGRAM = ARGF.read.split(',').map(&:to_i)

count = 0
SIZE_X.times do |x|
    SIZE_Y.times do |y|
        computer = Computer.new(PROGRAM.clone)
        computer.add_inputs([x, y])
        computer.run
        output = computer.read_and_clear_output
        count += output[0].to_i
    end
end
puts count
