#!/usr/bin/env ruby

def inverse_modulo(x, n)
    r = [n, x]
    t = [0, 1]
    while r[1] != 0
        q = r[0] / r[1]
        r = [r[1], r[0] - q * r[1]]
        t = [t[1], t[0] - q * t[1]]
    end
    t[0]
end

INPUT = ARGF.readlines.map(&:chomp).reverse
SIZE = 119315717514047
START_POSITION = 2020
ITERATIONS = 101741582076661

def iterate(position)
    INPUT.each do |shuffle|
        case shuffle
        when /cut (\d+)/
            n = $1.to_i
            if position < SIZE - n
                position += n
            else
                position -= SIZE - n
            end
        when /cut -(\d+)/
            n = $1.to_i
            if position < n
                position += SIZE - n
            else
                position -= n
            end
        when /deal into new stack/
            position = (SIZE - 1) - position
        when /deal with increment (\d+)/
            n = $1.to_i
            position = (position * inverse_modulo(n, SIZE)) % SIZE
        end
    end
    position
end

def find_cycle
    cycle = [START_POSITION]
    loop do
        position = iterate(cycle.last)
        if position == START_POSITION
            return cycle
        else
            cycle << position
        end
    end
end

cycle = find_cycle
puts cycle[ITERATIONS % cycle.size]
