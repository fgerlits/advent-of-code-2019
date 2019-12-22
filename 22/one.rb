#!/usr/bin/env ruby

INPUT = ARGF.readlines.map(&:chomp)
SIZE = 10007
position = 2019
INPUT.each do |shuffle|
    case shuffle
    when /cut (\d+)/
        n = $1.to_i
        if position < n
            position += SIZE - n
        else
            position -= n
        end
    when /cut -(\d+)/
        n = $1.to_i
        if position < SIZE - n
            position += n
        else
            position -= SIZE - n
        end
    when /deal into new stack/
        position = (SIZE - 1) - position
    when /deal with increment (\d+)/
        n = $1.to_i
        position = (position * n) % SIZE
    end
end
puts position
