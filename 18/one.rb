#!/usr/bin/env ruby

require_relative 'cave'

grid = Grid.new(ARGF.readlines)
puts grid.num_keys

distances = grid.find_paths_to_keys
puts distances.min
