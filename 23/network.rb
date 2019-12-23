require_relative '../common/intcode_computer'

class Network
    def initialize(num_nodes, program)
        @computers = Array.new(num_nodes){Computer.new(program.clone)}
        @queues = Array.new(num_nodes){[]}

        @computers.each_with_index do |computer, index|
            computer.add_inputs([index])
        end
    end

    def iterate
        finished = false
        @computers.zip(@queues).each do |computer, queue|
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
                    @queues[index] << x << y
                else
                    puts "#{index} <- #{x} #{y}"
                    finished = true
                end
            end
        end
        !finished
    end
end
