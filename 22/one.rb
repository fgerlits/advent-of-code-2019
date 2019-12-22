#!/usr/bin/env ruby

require_relative 'shuffle'

INPUT = ARGF.readlines.map(&:chomp)
SIZE = 10007
START_POSITION = 2019

a, c = compute_shuffle
p (a * START_POSITION + c) % SIZE
