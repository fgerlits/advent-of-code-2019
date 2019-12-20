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
        x, y, _ = @portals['AA'][0]
        @start_pos = [x, y, 0]
        x, y, _ = @portals['ZZ'][0]
        @end_pos = [x, y, 0]
    end

    def find_horizontal_portals(maze)
        portals = Hash.new([])
        maze.each_with_index do |row, y|
            row.each_with_index do |c, x|
                middle = row.size / 2
                if c == '.' && is_letter(row[x + 1]) && is_letter(row[x + 2])
                    in_or_out = if x > middle then 1 else -1 end
                    portals[row[x + 1, 2].join] += [[x, y, in_or_out]]
                elsif x >= 2 && c == '.' && is_letter(row[x - 2]) && is_letter(row[x - 1])
                    in_or_out = if x < middle then 1 else -1 end
                    portals[row[x - 2, 2].join] += [[x, y, in_or_out]]
                end
            end
        end
        portals
    end

    def find_vertical_portals(maze)
        find_horizontal_portals(maze.transpose).transform_values{|list| list.map{|x, y, d| [y, x, d]}}
    end

    def portal_neighbors(pos)
        portal = @portals.find{|label, positions| positions.any?{|x, y, d| [x, y] == pos[0..1]}}
        if portal && portal[1].size > 1
            x, y, ddepth = portal[1].reject{|x, y, d| [x, y] == pos[0..1]}[0]
            if pos[2] + ddepth >= 0
                [[x, y, pos[2] + ddepth]]
            else
                []
            end
        else
            []
        end
    end

    def neighbors(pos)
        four_directions_from(pos).select{|x, y, d| @maze[y][x] == '.'} + portal_neighbors(pos)
    end

    def four_directions_from(pos)
        [[-1, 0], [0, -1], [1, 0], [0, 1]].map{|dx, dy| [pos[0] + dx, pos[1] + dy, pos[2]]}
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
