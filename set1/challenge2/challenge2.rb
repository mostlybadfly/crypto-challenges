def fixed_xor(str1, str2)
  zipped = [str1].pack('H*').bytes.zip([str2].pack('H*').bytes)
  zipped.map { |x, y| (x ^ y).to_s(16) }.join
end
