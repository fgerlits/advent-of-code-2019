#!/usr/bin/env ruby

require_relative 'shuffle'

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

a, c = compute_shuffle

# invert
ax = inverse(a, SIZE) % SIZE
cx = (-c) * ax % SIZE

# power
an = power(ax, ITERATIONS, SIZE)
cn = (cx * (an - 1) * inverse(ax - 1, SIZE)) % SIZE

puts (an * START_POSITION + cn) % SIZE
