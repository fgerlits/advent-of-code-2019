#!/usr/bin/env ruby

def sign(number)
    number <=> 0
end

class Moon
    attr_reader :pos, :vel

    def initialize(pos, vel)
        @pos = pos
        @vel = vel
    end

    def gravity_from(other)
        sign(other.pos - @pos)
    end

    def to_s
        "pos=#{@pos}, vel=#{@vel}"
    end

    def inspect
        to_s
    end

    def ==(other)
        [@pos, @vel] == [other.pos, other.vel]
    end

    def eql?(other)
        self == other
    end

    def hash
        [@pos, @val].hash
    end
end

def read_moon(input)
    input =~ /<x=(.+), y=(.+), z=(.+)\>/
    [$1, $2, $3].map(&:to_i)
end

def find_cycle(moons)
    step = 0
    seen = {moons => step}
    loop do
        step += 1
        new_moons = moons.map do |moon|
            acceleration = moons.map{|other| moon.gravity_from(other)}.sum
            velocity = moon.vel + acceleration
            Moon.new(moon.pos + velocity, velocity)
        end

        if seen.include?(new_moons)
            return [seen[new_moons], step]
        end

        moons = new_moons
        seen[moons] = step
    end
end

if __FILE__ == $0
    coords = ARGF.readlines.map{|line| read_moon(line)}.transpose
                .map{|column| column.map{|pos| Moon.new(pos, 0)}}
    cycles = coords.map{|moons| find_cycle(moons)}
    cycles.each do |first, second|
        puts "start = #{first}, cycle length = #{second - first}"
    end
    puts "lcm = #{cycles.map{|_, cycle| cycle}.reduce(&:lcm)}"
end
