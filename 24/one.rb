#!/usr/bin/env ruby

require 'set'

EMPTY = '.'
BUG = '#'

class Eris
    attr_reader :grid

    def initialize(lines)
        @grid = lines.map{|line| line.chomp.each_char.to_a}
    end

    def at(x, y)
        if y >= 0 && y < @grid.size
            if x >= 0 && x < @grid[y].size
                @grid[y][x]
            end
        end || EMPTY
    end

    def neighbors(x, y)
        [[-1, 0], [1, 0], [0, -1], [0, 1]].map{|dx, dy| at(x + dx, y + dy)}
    end

    def rule(type, x, y)
        bugs = neighbors(x, y).count(BUG)
        case type
        when EMPTY
            if bugs == 1 || bugs == 2 then BUG else EMPTY end
        when BUG
            if bugs == 1 then BUG else EMPTY end
        end
    end

    def iterate!
        @grid = @grid.each_with_index.map{|row, y| row.each_with_index.map{|loc, x| rule(loc, x, y)}}
    end

    def score
        total = 0
        multiplier = 1
        @grid.flatten.each do |loc|
            if loc == BUG
                total += multiplier
            end
            multiplier *= 2
        end
        total
    end

    def eql?(other)
        @grid.eql?(other.grid)
    end

    def ==(other)
        self.eql?(other)
    end

    def hash
        @grid.hash
    end

    def to_s
        @grid.map{|row| row.join}.join("\n")
    end
end

INPUT = ARGF.readlines
eris = Eris.new(INPUT)
seen = Set.new
while !seen.include?(eris)
    puts eris
    puts
    seen << eris
    eris.iterate!
end
puts eris
puts
puts eris.score
