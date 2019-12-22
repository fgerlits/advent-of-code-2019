#!/usr/bin/env ruby

def inverse(x, n)
    r = [n, x]
    t = [0, 1]
    while r[1] != 0
        q = r[0] / r[1]
        r = [r[1], r[0] - q * r[1]]
        t = [t[1], t[0] - q * t[1]]
    end
    t[0]
end

def power(x, k, n)
    if k == 0
        1
    elsif k % 2 == 0
        a = power(x, k / 2, n)
        (a * a) % n
    else
        a = power(x, k / 2, n)
        (a * a * x) % n
    end
end

INPUT = ARGF.readlines.map(&:chomp)
SIZE = 119315717514047
START_POSITION = 2020
ITERATIONS = 101741582076661

def compute_shuffle
    a, c = 1, 0     # shuffle is ax + c
    INPUT.each do |shuffle|
        case shuffle
        when /cut (\d+)/
            n = $1.to_i
            c = (c - n) % SIZE
        when /cut -(\d+)/
            n = $1.to_i
            c = (c + n) % SIZE
        when /deal into new stack/
            a = (-a) % SIZE
            c = (-c - 1) % SIZE
        when /deal with increment (\d+)/
            n = $1.to_i
            a = (a * n) % SIZE
            c = (c * n) % SIZE
        end
    end
    [a, c]
end

a, c = compute_shuffle

# invert
ax = inverse(a, SIZE) % SIZE
cx = (-c) * ax % SIZE

# power
an = power(ax, ITERATIONS, SIZE)
cn = (cx * (an - 1) * inverse(ax - 1, SIZE)) % SIZE

puts (an * START_POSITION + cn) % SIZE
