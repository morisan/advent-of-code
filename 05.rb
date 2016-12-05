require 'digest/md5'

INPUT = 'uqwqemis'

class BobbyFischer

  def initialize(door_id)
    @door_id = door_id
  end

  def get_simple_password
    password = ''
    i = 0

    while password.length < 8 do
      h = Digest::MD5.hexdigest("#{@door_id}#{i}")
      password += h[5] if h[0..4] == '00000'
      i+=1
    end

    password
  end

  def get_advanced_password
    password = []
    chars_left = 8
    i = 0

    while chars_left.positive? do
      h = Digest::MD5.hexdigest("#{@door_id}#{i}")

      if h[0..4] == '00000' && h[5] < '8' && password[h[5].to_i].nil?
        password[h[5].to_i] = h[6]
        chars_left -= 1
      end

      i+=1
    end

    password.join()
  end

end

bf = BobbyFischer.new(INPUT)
puts "The simple password is: '#{bf.get_simple_password()}'"
puts "The advanced password is: '#{bf.get_advanced_password()}'"
