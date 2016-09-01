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

#decode_singlexor("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736",
#                 find_key("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"))
# => "Cooking MC's like a pound of bacon"
