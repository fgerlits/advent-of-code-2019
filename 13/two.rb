#!/usr/bin/env ruby

require_relative 'grid'
require_relative '../common/intcode_computer'

PROGRAM = ARGF.read.chomp.split(',').map{|w| w.to_i}
PROGRAM[0] = 2
PADDLE = 3
BALL = 4

computer = Computer.new(PROGRAM)
grid = Grid.new
score = 0
ball_column = 0
paddle_column = 0

loop do
    return_code = computer.run

    output = computer.read_and_clear_output
    output.each_slice(3) do |x, y, value|
        if [x, y] == [-1, 0]
            score = value
        else
            grid.put(x, y, value)
            case value
            when BALL
                ball_column = x
            when PADDLE
                paddle_column = x
            end
        end
        puts grid.to_s
        puts
    end

    if return_code == :exit
        break
    else
        joystick = if paddle_column < ball_column then 1
                   elsif paddle_column > ball_column then -1
                   else 0
                   end
        computer.add_inputs([joystick])
    end
end

puts grid.to_s
puts
puts "final score: #{score}"
