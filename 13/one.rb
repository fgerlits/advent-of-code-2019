#!/usr/bin/env ruby

require_relative 'grid'
require_relative '../common/intcode_computer'

PROGRAM = ARGF.read.chomp.split(',').map{|w| w.to_i}
computer = Computer.new(PROGRAM)

loop do
    return_code = computer.run
    break if return_code == :exit
end

grid = Grid.new
output = computer.read_and_clear_output
output.each_slice(3) do |x, y, tile|
    grid.put(x, y, tile)

    #puts grid.to_s
    #puts
end
#puts grid.to_s
puts grid.count(2)
