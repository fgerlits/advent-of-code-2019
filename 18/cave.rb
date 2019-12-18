require 'set'

def add(pos, dpos)
    pos.zip(dpos).map{|a, b| a + b}
end

class Grid
    attr_reader :start_pos, :num_keys

    def initialize(lines)
        @grid = lines.map{|line| line.chomp.each_char.to_a}
        @start_pos = find('@')
        @num_keys = @grid.map{|row| row.count{|c| ('a'..'z') === c}}.sum
    end

    def find(char)
        found = []
        @grid.each_with_index do |row, y|
            row.each_with_index do |c, x|
                if c == char
                    found << [x, y]
                end
            end
        end
        found
    end

    def modify_entrance
        start_pos = @start_pos[0]
        [[-1, 0], [0, 0], [1, 0], [0, -1], [0, 1]].each{|dpos| set(add(start_pos, dpos), '#')}
        [[-1, -1], [-1, 1], [1, -1], [1, 1]].each{|dpos| set(add(start_pos, dpos), '@')}
        @start_pos = find('@')
    end

    def to_s
        @grid.map(&:join).join("\n")
    end

    def at(pos)
        @grid[pos[1]][pos[0]]
    end

    def set(pos, value)
        @grid[pos[1]][pos[0]] = value
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
        min_distance = {}
        progress = 0
        todo_list = [[@start_pos, Set.new, 0]]
        while !todo_list.empty?
            pos, keys, total_distance = todo_list.shift
            if keys.size == @num_keys
                result << total_distance
            else
                if keys.size > progress
                    progress = keys.size
                    puts progress
                end
                pos.size.times do |index|
                    dfs(pos[index], keys).each do |key_pos, distance|
                        new_pos = pos.clone
                        new_pos[index] = key_pos
                        new_keys = keys + [at(key_pos)]
                        new_distance = total_distance + distance
                        if min_distance[[new_keys, new_pos]].nil? ||
                                    new_distance < min_distance[[new_keys, new_pos]]
                            min_distance[[new_keys, new_pos]] = new_distance
                            todo_list << [new_pos, new_keys, new_distance]
                        end
                    end
                end
            end
        end
        result
    end
end
