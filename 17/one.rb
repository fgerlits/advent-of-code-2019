#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

def intersection?(grid, x, y)
    x > 0 && x < grid[0].size - 1 &&
    y > 0 && y < grid.size - 1 &&
    [[x - 1, y], [x, y], [x + 1, y], [x, y - 1], [x, y + 1]].all?{|x, y| grid[y][x] == '#'}
end

def find_intersections(grid)
    result = []
    grid.each_with_index do |row, y|
        row.each_with_index do |loc, x|
            if intersection?(grid, x, y)
                result << [x, y]
            end
        end
    end
    result
end

PROGRAM = ARGF.read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
computer.run
output = computer.read_and_clear_output
grid = output.map{|n| n.chr}.chunk{|loc| loc != "\n" || nil}.map{|_, loc| loc}
intersections = find_intersections(grid)
puts intersections.map{|x, y| x * y}.sum
