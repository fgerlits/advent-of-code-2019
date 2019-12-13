#!/usr/bin/env ruby

PANELS = { 0 => '.',  # empty
           1 => '#',  # wall
           2 => '*',  # block
           3 => 'T',  # paddle
           4 => 'O' } # ball

class Grid
    def initialize
        @grid = {}
    end

    def get(x, y)
        @grid[[x, y]] || 0
    end

    def put(x, y, value)
        @grid[[x, y]] = value
    end

    def count(value)
        @grid.map{|k, v| v}.count(value)
    end

    def to_s
        if @grid.empty?
            ''
        else
            xmin, xmax = @grid.map{|pos, value| pos[0]}.minmax
            ymin, ymax = @grid.map{|pos, value| pos[1]}.minmax
            (ymin..ymax).map do |y|
                (xmin..xmax).map do |x|
                    PANELS[get(x, y)]
                end.join
            end.join("\n")
        end
    end
end
