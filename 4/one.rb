#!/usr/bin/env ruby

$increasing_m = {}
$strict_m = {}

def increasing(start, length)
    $increasing_m[[start, length]] ||= increasing_c(start, length)
end

def strict(start, length)
    $strict_m[[start, length]] ||= strict_c(start, length)
end

def increasing_c(start, length)
    if length == 1
        1
    else
        (start..9).map{|d| increasing(d, length - 1)}.sum
    end
end

def strict_c(start, length)
    if length == 1
        1
    else
        ((start + 1)..9).map{|d| strict(d, length - 1)}.sum
    end
end

1.upto(6) do |length|
    puts "length = #{length}"
    1.upto(9) do |start|
        puts "increasing: #{start} => #{increasing(start, length)}\t strict: #{start} => #{strict(start, length)}"
    end
    puts
end

def a(start, length)
    increasing(start, length) - strict(start, length)
end

puts a(9, 2) + a(8, 4) + a(9, 4) + a(5, 5) + a(6, 5) + a(7, 5) + a(8, 5) + a(9, 5) + a(2, 6) + a(3, 6) + a(4, 6) + a(5, 6) + a(6, 5) + a(7, 5) + a(8, 5)
