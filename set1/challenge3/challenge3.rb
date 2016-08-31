def letter_freq(input)
  count = 0
  input.each_char { |char| count +=1 if char.match(/[etaoinsrdlu]/) }
  count
end

def find_key(str)
  results = {}
  (0..255).each do |char|
    results[char] = letter_freq(decode_singlexor(str, char))
  end
  results.key(results.values.max)
end

def decode_singlexor(str, key)
  [str].pack('H*').bytes.map {|x| (x ^ key).chr }.join
end
