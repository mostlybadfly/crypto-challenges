require 'Base64'
require 'openssl'

def aes_in_ecb(data, key)
  data = Base64.decode64(data.delete("\n"))
  decipher = OpenSSL::Cipher::AES.new(128, :ECB)
  decipher.decrypt
  decipher.key = key
  decipher.update(data) + decipher.final
end

puts aes_in_ecb(File.read('7.txt'), "YELLOW SUBMARINE")
