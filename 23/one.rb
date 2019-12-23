#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

NUM_NODES = 50
PROGRAM = open('input').read.split(',').map(&:to_i)
computers = Array.new(NUM_NODES){Computer.new(PROGRAM.clone)}
queues = Array.new(NUM_NODES){[]}

computers.each_with_index do |computer, index|
    computer.add_inputs([index])
end

finished = false
loop do
    computers.zip(queues).each do |computer, queue|
        return_code = computer.run()
        case return_code
        when :wait_for_input
            if queue.empty?
                computer.add_inputs([-1])
            else
                computer.add_inputs(queue.shift(2))
            end
            computer.run()
        when :exit
            finished = true
        end
        outputs = computer.read_and_clear_output
        outputs.each_slice(3) do |index, x, y|
            if index >= 0 && index < NUM_NODES
                queues[index] << x << y
            else
                puts "#{index} <- #{x} #{y}"
                finished = true
            end
        end
    end
    if finished
        break
    end
end
