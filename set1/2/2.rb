def fixed_xor(str1, str2)
  zipped = [str1].pack('H*').bytes.zip([str2].pack('H*').bytes)
  zipped.map { |x, y| (x ^ y).to_s(16) }.join
end

# fixed_xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965")
# => 746865206b696420646f6e277420706c6179
