require 'digest/md5'

SALT = 'yjdafjpo'
ITERATIONS = 2016

class Pad

  def initialize(salt)
    @salt = salt
    @hash_cache = {}
  end

  def solve(stretching=false)
    key_cnt = 0
    i = 0

    while true
      if matches = get_hash(i, stretching).match(/(.)\1\1/)
        hook = matches[0]

        hook_i = i
        1000.times do
          hook_i += 1
          if matches = get_hash(hook_i, stretching).match(/(.)\1\1\1\1/)
            sinker = matches[0]
            if hook == sinker[0..2]
              key_cnt += 1
              return i if key_cnt == 64
            end
          end
        end
      end

      i += 1
    end
  end

  def get_hash(i, stretching=false)
    key = "#{i}#{stretching}"

    return @hash_cache[key] || begin
      h = Digest::MD5.hexdigest("#{@salt}#{i}")
      ITERATIONS.times { h = Digest::MD5.hexdigest(h) } if stretching
      @hash_cache[key] = h
      h
    end
  end

end

p = Pad.new(SALT)
puts "Ans1 :#{p.solve()}"
puts "Ans2 :#{p.solve(true)}"
