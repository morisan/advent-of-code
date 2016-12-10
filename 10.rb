class Bot
  attr_reader :low_value, :high_value

  def recieve_value!(value)
    value = value.to_i()

    if !@low_value
      @low_value = value
    elsif @low_value < value
      @high_value = value
    elsif @low_value > value
      @high_value = @low_value
      @low_value = value
    end
  end

  def has_both_values?
    @high_value && @low_value
  end

  def take_low_value!
    low_value = @low_value
    @low_value = nil
    low_value
  end

  def take_high_value!
    high_value = @high_value
    @high_value = nil
    high_value
  end

end


class ZoomZoom

  def initialize(input)
    @instructions = File.read(input).strip()
  end

  def find_bot_by_compare(low_value, high_value)
    @bots = {}
    @outputs = {}
    return self.walk_instructions!(@instructions.lines(), low_value, high_value)
  end

  def multiply_outputs(ids)
    @bots = {}
    @outputs = {}
    self.walk_instructions!(@instructions.lines())

    return @outputs.select { |k, _| ids.include?(k.to_i()) }.values.inject(:*)
  end

  def walk_instructions!(instructions, low_value=nil, high_value=nil)
    the_scraps = []

    instructions.each do |instr|
      instr.strip!
      if matches = instr.match(/^value (\d+) goes to bot (\d+)$/)
        value = matches[1]
        bot_id = matches[2]

        bot = (@bots[bot_id] ||= Bot.new())
        bot.recieve_value!(value)
      elsif matches = instr.match(/^bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)$/)
        bot_src_id = matches[1]
        bot_src = (@bots[bot_src_id] ||= Bot.new())

        if ( low_value && high_value ) && bot_src.low_value == low_value && bot_src.high_value == high_value
          return bot_src_id
        elsif bot_src.has_both_values?

          _low_value  = nil
          _high_value = nil

          id = matches[3]
          if matches[2] == 'bot'
            bot = (@bots[id] ||= Bot.new())
            _low_value = bot_src.take_low_value!
            bot.recieve_value!(_low_value)
          elsif matches[2] == 'output'
            @outputs[id] = bot_src.take_low_value!
          end

          id = matches[5]
          if matches[4] == 'bot'
            bot = (@bots[id] ||= Bot.new())
            _high_value = bot_src.take_high_value!
            bot.recieve_value!(_high_value)
          elsif matches[4] == 'output'
            @outputs[id] = bot_src.take_high_value!
          end
        else
          the_scraps << instr
        end
      end
    end

    self.walk_instructions!(the_scraps, low_value, high_value) if instructions.any?
  end

end

zz = ZoomZoom.new('./input_10.txt')
low = 17
high = 61
puts "Bot that compared value #{low} (low) with value #{high} (high): #{zz.find_bot_by_compare(low, high)}"
outputs_ids = [0,1,2]
puts "Multiplied output ids: #{outputs_ids} = #{zz.multiply_outputs(outputs_ids)}"
