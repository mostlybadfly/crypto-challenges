require 'base64'

def hex_to_base64(hexstring)
  Base64.encode64([hexstring].pack('H*')).delete("\n")
end
