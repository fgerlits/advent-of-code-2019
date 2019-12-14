#!/usr/bin/env ruby

require_relative 'reactions'

RULES = ARGF.readlines.map{|line| Rule.new(line)}
ORDERED_NAMES = ordered_names
TARGET = 1_000_000_000_000

def fuel_to_ore(amount_of_fuel)
    chemicals = [Chemical.new(amount_of_fuel, 'FUEL')]
    while !chemicals.all?{|chemical| chemical.name == 'ORE'}
        reduce!(chemicals)
    end
    chemicals.map{|chemical| chemical.amount}.sum
end

divisor = fuel_to_ore(1)
lower_bound = TARGET / divisor
upper_bound = lower_bound

while fuel_to_ore(upper_bound) <= TARGET
    upper_bound += lower_bound / 10
end

while upper_bound > lower_bound + 1
    mid = (lower_bound + upper_bound) / 2
    if fuel_to_ore(mid) <= TARGET
        lower_bound = mid
    else
        upper_bound = mid
    end
end

puts lower_bound
