#!/usr/bin/env ruby

def transform(signal)
    sum = 0
    signal.map{|elt| sum += elt}
          .map{|elt| elt.abs % 10}
end

INPUT = ARGF.read.chomp.each_char.map(&:to_i)

offset = INPUT[0, 7].join.to_i
signal = (INPUT * 10_000)[offset..-1]

signal.reverse!
100.times do
    signal = transform(signal)
end
signal.reverse!

puts signal[0...8].join
