require_relative '../common/intcode_computer'

class Network
    def initialize(num_nodes, program)
        @computers = Array.new(num_nodes){Computer.new(program.clone)}
        @queues = Array.new(num_nodes){[]}

        @computers.each_with_index do |computer, index|
            computer.add_inputs([index])
        end
    end

    def iterate(mode)
        finished = false

        @computers.zip(@queues).each do |computer, queue|
            return_code = computer.run()
            if return_code == :wait_for_input
                if queue.empty?
                    computer.add_inputs([-1])
                else
                    computer.add_inputs(queue.shift(2))
                end
                computer.run()
            end

            outputs = computer.read_and_clear_output
            outputs.each_slice(3) do |index, x, y|
                if index >= 0 && index < NUM_NODES
                    @queues[index] << x << y
                elsif index == 255
                    if mode == :one
                        puts "#{index} <- #{x} #{y}"
                        finished = true
                    else
                        @nat = [x, y]
                    end
                else
                    raise "unknown address #{index} for package #{[x, y]}"
                end
            end
        end

        if mode == :two && @queues.all?(&:empty?)
            @queues[0] += @nat
            if @nat[1] == @last_package
                puts @nat[1]
                finished = true
            else
                @last_package = @nat[1]
            end
        end

        !finished
    end
end
