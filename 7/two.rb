#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

INPUT = ARGF.read.chomp.split(',').map{|w| w.to_i}
SETTINGS = [5, 6, 7, 8, 9]

def run_computers(settings)
    computers = 5.times.map{Computer.new(INPUT.clone)}
    computers.zip(settings){|computer, setting| computer.add_inputs([setting])}
    message = [0]
    output_value = 0
    stopping = false
    loop do
        computers.each do |computer|
            computer.add_inputs(message)
            return_code = computer.run
            message = computer.read_and_clear_output()
            if return_code == :exit
                stopping = true
            end
            if message.empty?
                return output_value
            end
        end
        output_value = message[0]
        if stopping
            return output_value
        end
    end
end

puts SETTINGS.permutation.map{|settings| run_computers(settings)}.max
