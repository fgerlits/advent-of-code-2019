#!/usr/bin/env ruby

def abs_sum(array)
    array.map{|x| x.abs}.sum
end

def sign(number)
    if number < 0 then -1
    elsif number == 0 then 0
    else 1
    end
end

def add_vectors(left, right)
    left.zip(right).map{|l, r| l + r}
end

def format(vector)
    '<' + ['x', 'y', 'z'].zip(vector).map{|c, v| "#{c}=#{v}"}.join(',') + '>'
end

class Moon
    attr_reader :pos, :vel

    def initialize(pos, vel)
        @pos = pos
        @vel = vel
    end

    def energy
        abs_sum(@pos) * abs_sum(@vel)
    end

    def gravity_from(other)
        @pos.zip(other.pos).map{|this, that| sign(that - this)}
    end

    def to_s
        "pos=#{format(@pos)}, vel=#{format(@vel)}"
    end
end

def read_moon(input)
    input =~ /<x=(.+), y=(.+), z=(.+)\>/
    Moon.new([$1, $2, $3].map(&:to_i), [0, 0, 0])
end

ITERATIONS = ARGV.shift.to_i
moons = ARGF.readlines.map{|line| read_moon(line)}
puts moons
puts
ITERATIONS.times do
    new_moons = moons.map do |moon|
        acceleration = moons.map{|other| moon.gravity_from(other)}.transpose.map(&:sum)
        velocity = add_vectors(moon.vel, acceleration)
        Moon.new(add_vectors(moon.pos, velocity), velocity)
    end
    moons = new_moons
    puts moons
    puts
end
puts moons.map(&:energy).sum
