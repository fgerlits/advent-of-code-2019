#!/usr/bin/env ruby

require_relative 'reactions'

RULES = ARGF.readlines.map{|line| Rule.new(line)}
ORDERED_NAMES = ordered_names

chemicals = [Chemical.new(1, 'FUEL')]
while !chemicals.all?{|chemical| chemical.name == 'ORE'}
    reduce!(chemicals)
end
puts chemicals.map{|chemical| chemical.amount}.sum
