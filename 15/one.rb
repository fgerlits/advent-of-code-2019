#!/usr/bin/env ruby

require_relative '../common/intcode_computer'
require 'set'

MOVES = {1 => [0, -1],
         2 => [0, 1],
         3 => [-1, 0],
         4 => [1, 0]}

def add(pos, direction)
    pos.zip(MOVES[direction]).map{|left, right| left + right}
end

class Grid

    def initialize
        @grid = {}
        @pos = [0, 0]
    end

    def set(pos, value)
        @grid[pos.clone] = value
    end

    def get(pos)
        @grid[pos] || ' '
    end

    def new_pos(direction)
        add(@pos, direction)
    end

    def move(direction, value)
        case value
        when 0
            set(new_pos(direction), '#')
        when 1
            @pos = new_pos(direction)
            set(@pos, '.')
        when 2
            @pos = new_pos(direction)
            set(@pos, '*')
        end
    end

    def unexplored?(direction)
        get(new_pos(direction)) == ' '
    end

    def unexplored_directions
        [1, 2, 3, 4].select{|direction| unexplored?(direction)}
    end

    def to_s
        xmin, xmax = @grid.map{|k, v| k[0]}.minmax
        ymin, ymax = @grid.map{|k, v| k[1]}.minmax
        (ymin..ymax).map do |y|
            (xmin..xmax).map do |x|
                if [x, y] == @pos
                    'D'
                elsif [x, y] == [0, 0]
                    'S'
                else
                    get([x, y])
                end
            end.join
        end.join("\n")
    end
end

def make_move(computer, grid, direction)
    computer.add_inputs([direction])
    computer.run
    output = computer.read_and_clear_output[0]

    grid.move(direction, output)
    #puts grid
    #puts

    output
end

def opposite_of(direction)
    {1 => 2, 2 => 1, 3 => 4, 4 => 3}[direction]
end

def dfs(computer, grid)
    grid.unexplored_directions.each do |direction|
        output = make_move(computer, grid, direction)
        if output != 0
            dfs(computer, grid)
            make_move(computer, grid, opposite_of(direction))
        end
    end
end

def bfs(grid)
    seen = Set.new
    todo_list = [[[0, 0], 0]]
    while !todo_list.empty?
        pos, distance = todo_list.shift
        if grid.get(pos) == '*'
            return distance
        end
        [1, 2, 3, 4].each do |direction|
            new_pos = add(pos, direction)
            if !seen.include?(new_pos) && grid.get(new_pos) != '#'
                todo_list << [new_pos, distance + 1]
            end
        end
        seen << pos
    end
end

PROGRAM = ARGF.read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
grid = Grid.new

dfs(computer, grid)
puts bfs(grid)
