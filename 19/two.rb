#!/usr/bin/env ruby

require_relative '../common/intcode_computer'

SIZE_X, SIZE_Y = 2000, 2000

PROGRAM = ARGF.read.split(',').map(&:to_i)

def compute(x, y)
    computer = Computer.new(PROGRAM.clone)
    computer.add_inputs([x, y])
    computer.run
    output = computer.read_and_clear_output
    output[0].to_i
end

shape = SIZE_Y.times.map do |y|
    row = SIZE_X.times.map{|x| compute(x, y)}
    min = row.find_index(1)
    if !min.nil?
        max = row[min..-1].find_index(0)
        if !max.nil?
            [min, min + max]
        else
            [min, SIZE_X]
        end
    else
        [SIZE_X, SIZE_X]
    end
end

TARGET_X, TARGET_Y = 100, 100

y, top, bottom = SIZE_Y.times.zip(shape, shape[(TARGET_Y - 1)..-1])
    .find{|y, top, bottom| puts "#{y}: #{top}, #{bottom}"; top[1] >= bottom[0] + TARGET_X}
puts bottom[0] * 10_000 + y
