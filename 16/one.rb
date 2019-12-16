#!/usr/bin/env ruby

PATTERN = [0, 1, 0, -1]

def create_pattern(index, length)
    pattern = PATTERN.flat_map{|d| [d] * index}
    repeated_pattern = pattern * ((length + 1).to_f / pattern.length).ceil
    repeated_pattern[1, length]
end

def fft(signal, index)
    pattern = create_pattern(index, signal.length)
    signal.zip(pattern).map{|s, p| s * p}.sum.abs % 10
end

def transform(signal)
    signal.each_with_index.map{|_, i| fft(signal, i + 1)}
end

INPUT = ARGF.read.each_char.map(&:to_i)

signal = INPUT
100.times do
    signal = transform(signal)
end
puts signal[0...8].join
