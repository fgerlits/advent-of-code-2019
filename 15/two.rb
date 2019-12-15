#!/usr/bin/env ruby

require_relative 'oxygen'

PROGRAM = ARGF.read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
grid = Grid.new

dfs(computer, grid)
pos = grid.location_of_generator
grid.set(pos, '.')
puts bfs(grid, pos)
