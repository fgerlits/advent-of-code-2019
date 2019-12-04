#!/usr/bin/env ruby

def increasing?(digits)
    digits.each_cons(2).all?{|a, b| a <= b}
end

def has_exactly_two_repeating?(digits)
    digits.chunk_while{|before, after| before == after}.any?{|group| group.size == 2}
end

count = (147981..691423).count do |num|
    digits = num.to_s.each_char
    increasing?(digits) && has_exactly_two_repeating?(digits)
end

puts count
