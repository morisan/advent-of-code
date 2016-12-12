class AssemBunny
  def initialize(input, registers={})
    @instructions = File.readlines(input)
    @program_counter = 0
    @registers = registers
  end

  def run_program!
    while @program_counter < @instructions.count()
      instr = @instructions[@program_counter].strip()

      if matches = instr.match(/^jnz (\S+) (\S+)$/)
        if self.get_value(matches[1]) != 0
          @program_counter += self.get_value(matches[2])
          next
        end
      elsif matches = instr.match(/^cpy (\S+) (\S+)$/)
        @registers[matches[2]] = self.get_value(matches[1])
      elsif matches = instr.match(/^inc (\S+)$/)
        @registers[matches[1]] += 1
      elsif matches = instr.match(/^dec (\S+)$/)
        @registers[matches[1]] -= 1
      end

      @program_counter += 1
    end
  end

  def reg_a
    @registers['a']
  end

  def get_value(input)
    if matches = input.match(/^(a|b|c|d)$/)
      reg = matches[1]
      return @registers[reg].to_i()
    else
      return input.to_i()
    end
  end

end

ab = AssemBunny.new('./input_12.txt')
ab.run_program!
puts "No register init! Value in register A: #{ab.reg_a}"

ab = AssemBunny.new('./input_12.txt', { 'c' => 1 })
ab.run_program!
puts "Init register C to 1. Value in register A: #{ab.reg_a}"
