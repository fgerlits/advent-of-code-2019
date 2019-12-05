class Instruction
    def initialize(opcode)
        @instr = opcode % 100
        @modes = []
        mode = opcode / 100
        while mode != 0
            @modes << mode % 10
            mode /= 10
        end
    end

    def mode(position)
        @modes[position] || 0
    end

    def get(context, position)
        input = context.tape[context.ip + position + 1]
        case mode(position)
        when 0 then context.tape[input]
        when 1 then input
        end
    end

    def put(context, position, value)
        address = context.tape[context.ip + position + 1]
        context.tape[address] = value
    end

    def execute(context)
        case @instr
            when 1
                a = get(context, 0)
                b = get(context, 1)
                put(context, 2, a + b)
                context.advance(4)
            when 2
                a = get(context, 0)
                b = get(context, 1)
                put(context, 2, a * b)
                context.advance(4)
            when 3
                a = input()
                put(context, 0, a)
                context.advance(2)
            when 4
                a = get(context, 0)
                output(a)
                context.advance(2)
            when 5
                a = get(context, 0)
                b = get(context, 1)
                if a != 0
                    context.jump(b)
                else
                    context.advance(3)
                end
            when 6
                a = get(context, 0)
                b = get(context, 1)
                if a == 0
                    context.jump(b)
                else
                    context.advance(3)
                end
            when 7
                a = get(context, 0)
                b = get(context, 1)
                put(context, 2, if a < b then 1 else 0 end)
                context.advance(4)
            when 8
                a = get(context, 0)
                b = get(context, 1)
                put(context, 2, if a == b then 1 else 0 end)
                context.advance(4)
            when 99
                exit
        end
    end

    def input
        STDIN.readline.to_i
    end

    def output(value)
        puts "output: #{value}"
    end
end

class Computer
    attr_reader :tape, :ip

    def initialize(program)
        @tape = program
        @ip = 0
    end

    def advance(steps)
        @ip += steps
    end

    def jump(position)
        @ip = position
    end

    def step
        instruction = Instruction.new(@tape[@ip])
        instruction.execute(self)
    end

    def run
        loop do
            step
        end
    end
end
