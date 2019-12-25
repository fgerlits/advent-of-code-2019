#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

def try_all_combinations(items)
    commands = []
    0.upto(items.size) do |size|
        items.combination(size) do |subset|
            commands += items.map{|item| "drop #{item}\n"}
            commands += subset.map{|item| "take #{item}\n"}
            commands << "inv\n"
            commands << "west\n"
        end
    end
    commands.join
end

PROGRAM = open('input').read.split(',').map(&:to_i)
computer = Computer.new(PROGRAM)
loop do
    computer.run
    output = computer.read_and_clear_output
    puts output.map(&:chr).join
    input = STDIN.gets
    if !input
        break
    elsif input.chomp == "find weight"
        input = try_all_combinations(['fuel cell', 'candy cane', 'hypercube', 'coin', 'spool of cat6', 'weather machine', 'mutex', 'tambourine'])
    end
    computer.add_inputs(input.each_char.map(&:ord))
end
