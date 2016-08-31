def self.hamming(str1, str2)
  str1.bytes.zip(str2.bytes).inject(0) do |total, chars|
    total += (chars[0]^chars[1]).to_s(2).count("1")
  end
end

def self.parse(input_file)
  Base64.decode64(File.read(input_file))
end

def self.chunkify(str, keysize)
  chunks = str.bytes.each_slice(keysize).map { |piece| piece.map(&:chr).join }
  chunks.delete_if { |x| x.length < keysize }
end
# Need to decode64 somewhere here
def self.rank_keysize(input, keysize)
  dist = []
  chunks = chunkify(input, keysize)
  chunks.take(10).each_with_index do |chunk, index|
    dist << hamming(chunk, chunks[index + 1])/keysize if chunks[index + 1]
  end
  dist.inject(&:+).to_f/dist.size
end

def self.get_keysize(text_file)
  guesses = {}
  (2..40).each do |keysize|
    guesses[keysize] = rank_keysize(parse(text_file), keysize)
  end
  guesses.min_by { |guess, score| score }.first
end
# Create a method to run single xor on these bas64 string
def self.get_key(keysize)
  chunks = chunkify(parse('6.txt'), keysize)
  chunks = chunks.map(&:bytes).transpose
  results = []
  chunks.each { |group| results << single_xor(group) }
  results.map { |keypart| keypart.chr }.join
end

def self.single_xor(byte_array)
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
