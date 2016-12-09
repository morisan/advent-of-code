class BoomBoom

  def initialize(input_file)
    @input_str = File.read(input_file).strip()
    @max = 0
  end

  def decompressed_length_v1
    decompressed_length = 0

    str = @input_str.clone()

    while str.length > 0
      if matches = str.match(/^(\w+)$/) || str.match(/^(\w+)\(/)
        word = matches[1]
        length = word.length()
        str.slice!(0...length)
        decompressed_length += length
      elsif matches = str.match(/^\((\d+)x(\d+)\)/)
        chars = matches[1].to_i
        repeat = matches[2].to_i

        slice_length = matches[0].length() + chars
        str.slice!(0...slice_length)

        decompressed_length += chars * repeat
      end
    end

    decompressed_length
  end

  def decompressed_length_v2(incepstring=nil)
    decompressed_length = 0

    str = incepstring || @input_str.clone()
    temp = str.clone()

    while str.length > 0
      if matches = str.match(/^(\w+)$/) || str.match(/^(\w+)\(/)
        word = matches[1]
        length = word.length()
        str.slice!(0...length)
        decompressed_length += length
      elsif matches = str.match(/^\((\d+)x(\d+)\)/)
        chars = matches[1].to_i
        repeat = matches[2].to_i

        marker_length = matches[0].length()
        str.slice!(0...marker_length)

        incepstring = str.slice!(0...chars)
        decompressed_length += self.decompressed_length_v2(incepstring.clone()) * repeat
      end
    end

    decompressed_length
  end

end

bb = BoomBoom.new('./input_09.txt')
puts "V1 Decompressed length is #{bb.decompressed_length_v1()}"
puts "V2 Decompressed length is #{bb.decompressed_length_v2()}"
