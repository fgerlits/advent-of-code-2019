#!/usr/bin/env ruby

EMPTY = '.'
BUG = '#'

XSIZE, YSIZE = 5, 5

class Eris
    attr_reader :grid

    def initialize(lines)
        @grid = {0 => lines.map{|line| line.chomp.each_char.to_a}}
        @min_level, @max_level = 0, 0
    end

    def at(level, x, y)
        if level >= @min_level && level <= @max_level
            @grid[level][y][x]
        end || EMPTY
    end

    def neighbors(level, x, y)
        neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]].map{|dx, dy| [level, x + dx, y + dy]}
                    .select{|_, x, y| x >= 0 && x < XSIZE && y >= 0 && y < YSIZE}
        if x == 0
            neighbors << [level - 1, 1, 2]
        end
        if x == XSIZE - 1
            neighbors << [level - 1, 3, 2]
        end
        if y == 0
            neighbors << [level - 1, 2, 1]
        end
        if y == YSIZE - 1
            neighbors << [level - 1, 2, 3]
        end
        if [x, y] == [2, 1]
            neighbors += (0...XSIZE).map{|x| [level + 1, x, 0]}
        end
        if [x, y] == [2, 3]
            neighbors += (0...XSIZE).map{|x| [level + 1, x, YSIZE - 1]}
        end
        if [x, y] == [1, 2]
            neighbors += (0...YSIZE).map{|y| [level + 1, 0, y]}
        end
        if [x, y] == [3, 2]
            neighbors += (0...YSIZE).map{|y| [level + 1, XSIZE - 1, y]}
        end
        neighbors
    end

    def rule(level, x, y)
        bugs = neighbors(level, x, y).count{|ll, xx, yy| at(ll, xx, yy) == BUG}
        case at(level, x, y)
        when EMPTY
            if bugs == 1 || bugs == 2 then BUG else EMPTY end
        when BUG
            if bugs == 1 then BUG else EMPTY end
        end
    end

    def iterate!
        @grid = (@min_level - 1..@max_level + 1).map do |level|
            [level,
            (0...YSIZE).map do |y|
                (0...XSIZE).map do |x|
                    if [x, y] != [2, 2]
                        rule(level, x, y)
                    else
                        EMPTY
                    end
                end
            end
            ]
        end.to_h
        if count_bugs_on_level(@min_level - 1) != 0
            @min_level -= 1
        end
        if count_bugs_on_level(@max_level + 1) != 0
            @max_level += 1
        end
    end

    def count_bugs_on_level(level)
        @grid[level].flatten.map{|loc| {EMPTY => 0, BUG => 1}[loc]}.sum
    end

    def count_bugs
        @grid.map{|level, _| count_bugs_on_level(level)}.sum
    end

    def to_s_level(level)
        @grid[level].map{|row| row.join}.join("\n")
    end

    def to_s
        (@min_level..@max_level).map do |level|
            "level #{level}\n#{to_s_level(level)}\n"
        end.join("\n")
    end
end

INPUT = ARGF.readlines
eris = Eris.new(INPUT)
#puts eris
#puts
200.times do
    eris.iterate!
    #puts "###########################################"
    #puts
    #puts eris
    #puts
end
puts eris.count_bugs
