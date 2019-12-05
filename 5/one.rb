#!/usr/bin/env ruby

require_relative 'intcode_computer'

if __FILE__ == $0
    input = open(ARGV[0]).read.chomp.split(',').map{|w| w.to_i}
    computer = Computer.new(input)
    computer.run
end
