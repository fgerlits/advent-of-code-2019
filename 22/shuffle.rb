def compute_shuffle
    a, c = 1, 0     # shuffle is ax + c
    INPUT.each do |shuffle|
        case shuffle
        when /cut (\d+)/
            n = $1.to_i
            c = (c - n) % SIZE
        when /cut -(\d+)/
            n = $1.to_i
            c = (c + n) % SIZE
        when /deal into new stack/
            a = (-a) % SIZE
            c = (-c - 1) % SIZE
        when /deal with increment (\d+)/
            n = $1.to_i
            a = (a * n) % SIZE
            c = (c * n) % SIZE
        end
    end
    [a, c]
end
