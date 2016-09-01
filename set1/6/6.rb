require 'Base64'

def hamming(str1, str2)
  str1.bytes.zip(str2.bytes).inject(0) do |total, chars|
    total += (chars[0]^chars[1]).to_s(2).count("1")
  end
end

def parse(input_file)
  Base64.decode64(File.read(input_file))
end

def chunkify(str, keysize)
  chunks = str.bytes.each_slice(keysize).map { |piece| piece.map(&:chr).join }
  chunks.delete_if { |x| x.length < keysize }
end

def rank_keysize(input, keysize)
  dist = []
  chunks = chunkify(input, keysize)
  chunks.take(10).each_with_index do |chunk, index|
    dist << hamming(chunk, chunks[index + 1])/keysize if chunks[index + 1]
  end
  dist.inject(&:+).to_f/dist.size
end

def get_keysize(textfile)
  guesses = {}
  (2..40).each do |keysize|
    guesses[keysize] = rank_keysize(textfile, keysize)
  end
  guesses.min_by { |guess, score| score }.first
end

def get_key(keysize, textfile)
  chunks = chunkify(textfile, keysize)
  chunks = chunks.map(&:bytes).transpose
  results = []
  chunks.each { |group| results << single_xor(group) }
  results.map { |keypart| keypart.chr }.join
end

def letter_freq(input)
  count = 0
  input.each_char { |char| count +=1 if char.match(/[etaoinsrdlu\s]/) }
  count
end

def single_xor(byte_array)
  results = []
  (0..255).each do |char|
    output = byte_array.map {|x| (x ^ char).chr }.join
    score = letter_freq(output)
    results << [char , output, score]
  end

  results.sort_by! { |x| -x[2] }
  top = results.first
  if top[2] > 8
    top[0]
  end
end

# textfile = parse('6.txt')
# puts get_key(get_keysize(textfile), textfile)
# => "Terminator X: Bring the noise"
