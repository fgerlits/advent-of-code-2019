#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

INPUT = ARGF.read.chomp.split(',').map{|w| w.to_i}
SETTINGS = [0, 1, 2, 3, 4]

results = SETTINGS.permutation.map do |settings|
    value = 0
    5.times do
        computer = Computer.new(INPUT.clone)
        output = computer.run([settings.shift, value])
        value = output[0]
    end
    value
end
    
puts results.max
