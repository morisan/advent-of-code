class Lit

  def initialize(input_file)
    @screen = [
      Array.new(50, ' '),
      Array.new(50, ' '),
      Array.new(50, ' '),
      Array.new(50, ' '),
      Array.new(50, ' '),
      Array.new(50, ' ')
    ]

    File.read(input_file).each_line do |line|
      if matches = line.match(/^rect (\d+)x(\d+)$/)
        self.rect!(matches[1].to_i, matches[2].to_i)
      elsif matches = line.match(/^rotate row y=(\d+) by (\d+)$/)
        self.rotate_row!(matches[1].to_i, matches[2].to_i)
        next
      elsif matches = line.match(/^rotate column x=(\d+) by (\d+)$/)
        self.rotate_col!(matches[1].to_i, matches[2].to_i)
        next
      end
    end
  end

  def rect!(px_wide, px_tall)
    @screen.each.with_index do |row, index|
      return if index == px_tall

      px_wide.times { |i| row[i] = '#' }
    end
  end

  def rotate_row!(index, shift_pixels)
    @screen[index].rotate!(-1 * shift_pixels)
  end

  def rotate_col!(index, shift_pixels)
    t = @screen.transpose()
    t[index].rotate!(-1 * shift_pixels)
    @screen = t.transpose()
  end

  def get_how_many_pixels_lit
    @screen.map { |row| row.count('#') }.inject(0){ |sum, x| sum + x }
  end

  def print_screen
    @screen.each { |r| puts "#{r.join}" }
  end

end

l = Lit.new('./input_8.txt')
puts "#{l.get_how_many_pixels_lit()} pixels are lit in this screen:"
l.print_screen()
