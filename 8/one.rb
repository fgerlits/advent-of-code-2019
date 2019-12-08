#!/usr/bin/env ruby

input = ARGF.read.chomp.each_char.map{|c| c.to_i}.each_slice(25 * 6).to_a
layer = input.min_by{|l| l.count(0)}
puts layer.count(1) * layer.count(2)
