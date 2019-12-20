#!/usr/bin/env ruby

require 'set'

def is_letter(char)
    ('A'..'Z') === char
end

class Maze
    def initialize(lines)
        @maze = lines.map{|line| line.chomp.each_char.to_a}
        horizontal = find_horizontal_portals(@maze)
        vertical = find_vertical_portals(@maze)
        @portals = horizontal.merge(vertical){|key, left, right| left + right}
        @start_pos = @portals['AA'][0]
        @end_pos = @portals['ZZ'][0]
    end

    def find_horizontal_portals(maze)
        portals = Hash.new([])
        maze.each_with_index do |row, y|
            row.each_with_index do |c, x|
                if c == '.' && is_letter(row[x + 1]) && is_letter(row[x + 2])
                    portals[row[x + 1, 2].join] += [[x, y]]
                elsif x >= 2 && c == '.' && is_letter(row[x - 2]) && is_letter(row[x - 1])
                    portals[row[x - 2, 2].join] += [[x, y]]
                end
            end
        end
        portals
    end

    def find_vertical_portals(maze)
        find_horizontal_portals(maze.transpose).transform_values{|list| list.map(&:reverse)}
    end

    def portal_neighbors(pos)
        portal = @portals.find{|label, positions| positions.include?(pos)}
        if portal
            portal[1] - [pos]
        else
            []
        end
    end

    def neighbors(pos)
        four_directions_from(pos).select{|x, y| @maze[y][x] == '.'} + portal_neighbors(pos)
    end

    def four_directions_from(pos)
        [[-1, 0], [0, -1], [1, 0], [0, 1]].map{|dx, dy| [pos[0] + dx, pos[1] + dy]}
    end

    def bfs
        seen = Set.new
        todo_list = [[@start_pos, 0]]
        while !todo_list.empty?
            pos, distance = todo_list.shift
            seen << pos
            if pos == @end_pos
                return distance
            end
            neighbors(pos).each do |neighbor|
                if !seen.include?(neighbor)
                    todo_list << [neighbor, distance + 1]
                end
            end
        end
        raise 'could not find the exit'
    end
end

maze = Maze.new(ARGF.readlines)
puts maze.bfs
