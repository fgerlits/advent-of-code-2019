#!/usr/bin/env ruby

def add(front, back)
    front.zip(back).map{|f, b| if f == "2" then b else f end}
end

input = ARGF.read.chomp.each_char.each_slice(25 * 6).to_a
result = input.reduce{|f, b| add(f, b)}
puts result.each_slice(25).map{|row| row.map{|c| if c == "1" then "#" else " " end}.join}
