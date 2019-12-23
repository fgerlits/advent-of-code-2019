#!/usr/bin/env ruby

require_relative 'network'

NUM_NODES = 50
PROGRAM = open('input').read.split(',').map(&:to_i)
network = Network.new(NUM_NODES, PROGRAM)

while network.iterate(:two)
end
