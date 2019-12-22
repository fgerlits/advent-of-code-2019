#!/usr/bin/env ruby

def cut_positive(cards, n)
    cut = cards.shift(n)
    cards + cut
end

def cut_negative(cards, n)
    cut = cards.pop(n)
    cut + cards
end

def reverse(cards)
    cards.reverse
end

def multiply(cards, n)
    result = [0] * SIZE
    cards.each_with_index do |card, i|
        result[(i * n) % SIZE] = card
    end
    result
end

INPUT = ARGF.readlines.map(&:chomp)
SIZE = 10007
cards = (0...SIZE).to_a
INPUT.each do |shuffle|
    case shuffle
    when /cut -(\d+)/
        cards = cut_negative(cards, $1.to_i)
    when /cut (\d+)/
        cards = cut_positive(cards, $1.to_i)
    when /deal into new stack/
        cards = reverse(cards)
    when /deal with increment (\d+)/
        cards = multiply(cards, $1.to_i)
    end
end
puts cards.find_index(2019)
