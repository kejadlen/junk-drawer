MESSAGES = {
  example: 'ASVDZC', # BILBO
  windmill: 'JEIYQWN-BC-EHDKA',
  well: 'XOV-PKXZVK-UEVKA-GQR',
  fence: 'PHCDN-LHFZH-CE-WDRQE',
  gate: 'XRD-BRPITWAFP',
  village_cart: 'E-LDLPNK-OZ-KHZN',
  village: 'HJJLIDEB-XAANQKCJB',
  signpost: 'LJL-PH-EDJMC-ZKHE',
  cave: 'CORKZBH-NRBNP-BZ',
  mt_doom: 'LBCWT-BDXZHU-IYH-FNQNAR-PWRML',
}

ALPHABET = (?A..?Z).to_a

def decode_char(key_char, rune)
  alphabet = ALPHABET
  i = 0
  while alphabet[0] != key_char
    i += 1
    alphabet = alphabet.rotate
  end
  alphabet[rune.bytes[0]-65]
end

def decode(key_phrase, message)
  decoded = message.split(//).map do |char|
    next char unless char =~ /[A-Z]/
    key_phrase = key_phrase.rotate
    decode_char(key_phrase[-1], char)
  end
  decoded.join
end

key_phrase = ARGV.join.upcase.split(//)

MESSAGES.each do |key, message|
  puts "#{key}: #{decode(key_phrase, message)}"
end
