#!/usr/bin/env ruby

class Grid
    def initialize
        @grid = {}
        @position = [0, 0]
        @heading = [0, -1]
    end

    def get
        @grid[@position] || 0
    end

    def put(value)
        @grid[@position.clone] = value
    end

    def turn(direction)
        case direction
        when 0
            @heading = [@heading[1], - @heading[0]]
        when 1
            @heading = [- @heading[1], @heading[0]]
        end
    end

    def move
        @position[0] += @heading[0]
        @position[1] += @heading[1]
    end

    def count
        @grid.size
    end

    def to_s
        if @grid.empty?
            ''
        else
            xmin, xmax = @grid.map{|pos, value| pos[0]}.minmax
            ymin, ymax = @grid.map{|pos, value| pos[1]}.minmax
            (ymin..ymax).map do |y|
                (xmin..xmax).map do |x|
                    if @grid[[x, y]] == 1
                        '#'
                    else
                        '.'
                    end
                end.join
            end.join("\n")
        end
    end
end
