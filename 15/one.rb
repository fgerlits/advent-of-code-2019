#!/usr/bin/env ruby

require_relative 'oxygen'

PROGRAM = ARGF.read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
grid = Grid.new

dfs(computer, grid)
puts bfs(grid, [0, 0])
