def hamming_dist(str1, str2, keysize)
  arry = str1.bytes.zip(str2.bytes)
  result = []
  arry.each do |n1, n2|
    result << (n1^n2).to_s(2).count("1")
  end
  result.inject(&:+)
  # => 37
end

def read_lines(txtfile)
  @long_string = ""
  File.open(txtfile).readlines.each do |line|
    @long_string << line.chomp
  end
end

def chunky(str, keysize)
  @chunks = str.bytes.each_slice(keysize).to_a.map{|x| x.map(&:chr).join} 
  @chunks.delete_if {|x| x.length < keysize}
end
@guesses = {}
def get_keysize(guess)
  @scores = []
  chunky(@long_string, guess)
  @chunks.each_slice(2).to_a.each do |chunk1, chunk2|
    if chunk2
      @scores << hamming_dist(chunk1, chunk2, guess).to_f/guess
    end
  end
  @guesses[guess] = @scores.inject(&:+).to_f/@scores.size

end


# create method to iterate through keysize (2..40).to_a, to pass through #chunky and #hamming_dist

