  def self.repeated_xor(string, key)
   zipped =string.bytes.zip(key.bytes.cycle)
   zipped.map { |x, y| sprintf("%02x", (x ^ y)) }.join
  end
