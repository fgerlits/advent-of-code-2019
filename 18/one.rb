#!/usr/bin/env ruby

require 'set'

def add(pos, dpos)
    pos.zip(dpos).map{|a, b| a + b}
end

class Grid
    attr_reader :start_pos

    def initialize(lines)
        @grid = lines.map{|line| line.chomp.each_char.to_a}
        @start_pos = find('@')
        @num_keys = @grid.map{|row| row.count{|c| ('a'..'z') === c}}.sum
    end

    def find(char)
        row, y = @grid.each_with_index.find{|row, y| row.include?(char)}
        x = row.find_index(char)
        [x, y]
    end

    def to_s
        @grid.map(&:join).join("\n")
    end

    def at(pos)
        @grid[pos[1]][pos[0]]
    end

    def dfs(start, keys)
        found = []
        seen = Set.new
        todo_list = [[start, 0]]
        while !todo_list.empty?
            pos, distance = todo_list.shift
            seen << pos
            [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dpos|
                new_pos = add(pos, dpos)
                if !seen.include?(new_pos)
                    case at(new_pos)
                    when '.', '@'
                        todo_list << [new_pos, distance + 1]
                    when 'a'..'z'
                        if keys.include?(at(new_pos))
                            todo_list << [new_pos, distance + 1]
                        else
                            found << [new_pos, distance + 1]
                        end
                    when 'A'..'Z'
                        if keys.include?(at(new_pos).downcase)
                            todo_list << [new_pos, distance + 1]
                        end
                    end
                end
            end
        end
        found
    end

    def find_paths_to_keys
        result = []
        todo_list = [[start_pos, [], 0]]
        while !todo_list.empty?
            pos, keys, total_distance = todo_list.shift
            if keys.size == @num_keys
                result << total_distance
            else
                dfs(pos, keys).each do |key_pos, distance|
                    #puts "keys: #{keys}, new key: #{at(key_pos)}"
                    todo_list << [key_pos, keys + [at(key_pos)], total_distance + distance]
                end
            end
        end
        result
    end
end
        
grid = Grid.new(ARGF.readlines)

distances = grid.find_paths_to_keys
puts distances.min
