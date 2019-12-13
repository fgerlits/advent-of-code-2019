#!/usr/bin/env ruby

require_relative 'grid'
require_relative '../common/intcode_computer'

STARTING_PANEL = ARGV.shift.to_i
PROGRAM = ARGF.read.chomp.split(',').map{|w| w.to_i}
computer = Computer.new(PROGRAM)
grid = Grid.new
grid.put(STARTING_PANEL)

loop do
    computer.add_inputs([grid.get])
    return_code = computer.run
    output = computer.read_and_clear_output

    output.each_slice(2) do |paint, direction|
        grid.put(paint)
        grid.turn(direction)
        grid.move
    end

    #puts grid.to_s
    #puts

    break if return_code == :exit
end
puts grid.to_s
puts grid.count
