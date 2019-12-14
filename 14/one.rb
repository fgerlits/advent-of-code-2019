#!/usr/bin/env ruby

class Chemical
    attr_reader :amount, :name

    def initialize(amount, name)
        @amount = amount.to_i
        @name = name
    end

    def *(multiplier)
        Chemical.new(@amount * multiplier, @name)
    end

    def increase_amount(additional_amount)
        @amount += additional_amount
    end

    def to_s
        "#{@amount} #{@name}"
    end
end

class Rule
    attr_reader :inputs, :output

    def initialize(line)
        chemicals = line.scan(/[\w]+/).each_slice(2).map{|amount, name| Chemical.new(amount, name)}
        @inputs = chemicals[0...-1]
        @output = chemicals[-1]
    end

    def has_input?(name)
        @inputs.any?{|input| input.name == name}
    end

    def apply_reverse(chemical)
        multiplier = (chemical.amount.to_f / @output.amount).ceil
        @inputs.map{|input| input * multiplier}
    end
end

RULES = ARGF.readlines.map{|line| Rule.new(line)}

def ordered_names
    rules = RULES.clone
    order = []
    while !rules.empty?
        output = rules.map{|rule| rule.output.name}
                      .find{|name| rules.all?{|rule| !rule.has_input?(name)}}
        order << output
        rules.delete_if{|rule| rule.output.name == output}
    end
    order << 'ORE'
    order.reverse
end

ORDERED_NAMES = ordered_names

def reduce!(chemicals)
    max_item = chemicals.max_by{|chemical| ORDERED_NAMES.find_index(chemical.name)}
    rule = RULES.find{|rule| rule.output.name == max_item.name}
    chemicals.delete(max_item)
    rule.apply_reverse(max_item).each do |new_item|
        existing_item = chemicals.find{|chemical| chemical.name == new_item.name}
        if existing_item
            existing_item.increase_amount(new_item.amount)
        else
            chemicals << new_item
        end
    end
end

chemicals = [Chemical.new(1, 'FUEL')]
while !chemicals.all?{|chemical| chemical.name == 'ORE'}
    reduce!(chemicals)
end
puts chemicals.map{|chemical| chemical.amount}.sum
