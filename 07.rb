class CrazyIP

  def initialize(input_file)
    @addresses = File.read(input_file)
  end

  def support_tls_count
    count = 0
    @addresses.each_line do |addr|
      parts = addr.split(/[\[,\]]/)
      good_abba = false
      bad_abba = false


      parts.each.with_index(1) do |p, i|
        if i.odd?
          good_abba = is_abba?(p) if !good_abba
        else
          bad_abba = is_abba?(p) if !bad_abba
        end
      end

      count += 1 if good_abba && !bad_abba
    end

    return count
  end

  def support_ssl_count
    count = 0
    @addresses.each_line do |addr|
      supports_ssl = false

      parts = addr.split(/[\[,\]]/)
      supernets = parts.select.with_index(1) { |v,i| i.odd? }
      hypernets = parts - supernets

      babs_map = {}
      supernets.each do |sn|
        buf = []

        sn.each_char do |c|
          buf << c
          buf.shift() if buf.length() > 3

          if buf.length() == 3 && buf[0] != buf[1] && buf[0] == buf[2]
            babs_map["#{aba_to_bab(buf)}"] = buf
          end
        end
      end

      hypernets.each do |hn|
        buf = []

        hn.each_char do |c|
          buf << c
          buf.shift() if buf.length() > 3

          if buf.length() == 3 && buf[0] != buf[1] && buf[0] == buf[2]
            supports_ssl = true if !babs_map[buf.join()].nil?
          end
        end
      end

      count += 1 if supports_ssl
    end

    return count
  end

  private

  def is_abba?(text)
    buf = []

    text.each_char do |c|
      buf << c
      buf.shift() if buf.length() > 4

      return true if buf.length == 4 && buf[0] != buf[1] && buf[0] == buf[3] && buf[1] == buf[2]
    end

    return false
  end

  def aba_to_bab(aba)
    return aba[1] + aba[0] + aba[1]
  end

end


cip = CrazyIP.new('./input_7.txt')
puts "#{cip.support_tls_count()} addresses support TLS"
puts "#{cip.support_ssl_count()} addresses support SSL"
