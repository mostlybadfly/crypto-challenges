def detect_singlexor(text_file)
  candidates = []
  File.open(text_file).readlines.each do |line|
    candidates << find_key(line.chomp)
  end
  candidates.sort_by! { |x| -x[3] }.first
end

def find_key(hexstring)
  results = []
  (0..255).each do |char|
    output = decode_singlexor(hexstring, char).chomp
    score = letter_freq(output)
    results << [hexstring, char , output, score]
  end

  results.sort_by! { |x| -x[3] }.first
end

def decode_singlexor(str, key)
  [str].pack('H*').bytes.map { |x| (x ^ key).chr }.join
end

def letter_freq(input)
  count = 0
  input.each_char { |char| count +=1 if char.match(/[etaoinsrdlu\s]/) }
  count
end
