require 'base64'
require 'openssl'

class Crypto
  def self.parse_input(text_file)
    lines = []
    input = File.open(text_file)
    input.readlines.each do |line|
      lines << line.chomp
    end
    lines
  end
  # moved
  def self.to_base64(hexstring)
     package = [hexstring].pack('H*')
     output = [package].pack('m*')
     p output.delete("\n")
  end
#moved
  def self.fixedxor(a, b)
    arry_a = [a].pack('H*').bytes.to_a
    arry_b = [b].pack('H*').bytes.to_a
    zipped = arry_a.zip(arry_b)
    out = zipped.map { |x, y| (x ^ y). to_s(16) }.join
    p out
  end
#moved
  def self.letter_freq(string)
    count = {}
    common = /[etaoins]/

    string.each_char do |ltr|
      if ltr.match common
        count[ltr] = 0 unless count.include?(ltr)
        count[ltr] += 1
      else
        count[ltr] = 0
      end
    end
    count.values.inject(:+)
  end
#moved
  def self.singlexor(hexstring)
    hexbytes = Array(hexstring).pack('H*').bytes.to_a
    results = []
    (0..255).each do |char|
      output = hexbytes.map {|x| (x ^ char).chr }.join
      score = letter_freq(output)
      results << [char , output, score]
    end

    results.sort_by! { |x| -x[2] }
    top = results.first
    if top[2] > 8
      p "XOR'd char: #{top[0].to_s}|string: #{top[1]}|score: #{top[2]}"
    end
  end
#moved
  def self.repeated_xor(string, key)
   string = string.bytes
   key = key.bytes
   zipped = string.zip(key.cycle)
   p zipped.map { |x, y| sprintf("%02x", (x ^ y)) }.join
  end
#moved
  def self.hamming(str1, str2)
    result = []
    str1.bytes.zip(str2.bytes) do |n1, n2|
      result << (n1^n2).to_s(2).count("1")
    end
    result.inject(&:+)
  end

  def self.parse(input_file)
    Base64.decode64(File.read(input_file))
  end

  def self.chunkify(str, keysize)
    chunks = str.bytes.each_slice(keysize).map { |piece| piece.map(&:chr).join }
    chunks.delete_if { |x| x.length < keysize }
  end
  
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
#moved  
  def self.aes_in_ecb(data, key)
    decipher = OpenSSL::Cipher::AES.new(128, :ECB)
    decipher.decrypt
    decipher.key = key
    decipher.update(data) + decipher.final
  end
#moved
  def self.detect_aes(data)
    data = File.open(data).read.split("\n")
    data.each do |x|
      group = x.bytes.each_slice(16).map { |piece| piece.map(&:chr).join }
      puts x if group.size > group.uniq.size
    end
  end
  #Set 2: Challenge 9
  # idea for a way to get the padding for each group, needs to be done with variables.
  # taking the `goal` minus current length. N bytes short, padding N times
  def self.pad(message, block_length)
    message = message.bytes
    padding = block_length - message.length
    padding.times { message << padding }
    message.pack('C*')
  end
end


# Set1:Challenge1
#Crypto.to_base64('49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d')
# => "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

# Set1:Challenge2
#Crypto.fixedxor('1c0111001f010100061a024b53535009181c', '686974207468652062756c6c277320657965')
# => "746865206b696420646f6e277420706c6179"

# Set1:Challenge3
Crypto.singlexor('1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736')
# => "XOR'd char: 58|string: Cooking MC's like a pound of bacon|score: 14"

# Set1:Challege4
Crypto.parse_input('S1C4.txt')
# => "XOR'd char: 53|string: Now that the party is jumping\n|score: 12"

# Set1:Challenge5
Crypto.repeated_xor("Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal", "ICE")
