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
                a = context.input()
                if !a.nil?
                    put(context, 0, a)
                    context.advance(2)
                else
                    return :wait_for_input
                end
            when 4
                a = get(context, 0)
                context.output(a)
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
                return :exit
        end
        return :continue
    end
end

class Computer
    attr_reader :tape, :ip

    def initialize(program)
        @tape = program
        @ip = 0
        @input = []
        @output = []
    end

    def advance(steps)
        @ip += steps
    end

    def jump(position)
        @ip = position
    end

    def input
        @input.shift
    end

    def output(value)
        @output << value
    end

    def add_inputs(values)
        @input += values
    end

    def read_and_clear_output
        output = @output
        @output = []
        output
    end

    def run
        loop do
            instruction = Instruction.new(@tape[@ip])
            return_code = instruction.execute(self)
            if return_code != :continue
                return return_code
            end
        end
    end
end
