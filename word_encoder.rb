# frozen_string_literal: true

class WordEncoder
  MORSE_MAP = { 'A' => '.-', 'B' => '-...', 'C' => '-.-.', 'D' => '-..', 'E' => '.', 'F' => '..-.', 'G' => '--.',
                'H' => '....', 'I' => '..', 'J' => '.---', 'K' => '-.-', 'L' => '.-..', 'M' => '--', 'N' => '-.',
                'O' => '---', 'P' => '.--.', 'Q' => '--.-', 'R' => '.-.', 'S' => '...', 'T' => '-', 'U' => '..-',
                'V' => '...-', 'W' => '.--', 'X' => '-..-', 'Y' => '-.--', 'Z' => '--..', '0' => '-----',
                '1' => '.----', '2' => '..---', '3' => '...--', '4' => '....-', '5' => '.....', '6' => '-....',
                '7' => '--...', '8' => '---..', '9' => '----.', '.' => '.-.-.-', ',' => '--..--' }.freeze

  def self.encode_string_or_file(string_or_path)
    new(string_or_path).encode_string
  end

  def initialize(string_or_path)
    @string = string_or_path
    @string = File.read(string_or_path).strip if looks_like_path?(string_or_path)
    @error = 'You cannot encode an empty message!' if string_empty?
  rescue Errno::ENOENT
    @error = "The file '#{string_or_path}' does not exist!"
  end

  def encode_string
    return display_error_message if error
    encoded_string = string.split(/\s+/).map do |word|
      convert_word_to_morse_and_encode(word)
    end.join('/')
    puts encoded_string
  end

private

  attr_reader :string, :error

  def convert_word_to_morse_and_encode(word)
    word.scan(/\w/).map do |char|
      morse_char = MORSE_MAP[char]
      encode_letter(morse_char)
    end.join('|')
  end

  def encode_letter(letter_in_morse)
    encoded_letter_string = previous_char = ''
    count = 1
    letter_in_morse.split('').each do |char|
      if previous_char == ''
      elsif previous_char == char
        count += 1
      else
        encoded_letter_string += string_to_add(count, previous_char)
        count = 1
      end
      previous_char = char
    end
    encoded_letter_string += string_to_add(count, previous_char)
  end

  def string_to_add(count, char)
    char == '-' ? ('a'..'z').to_a[count - 1].upcase : count.to_s
  end

  def looks_like_path?(string_or_path)
    string_or_path.match(/\//)
  end

  def string_empty?
    string.nil? || string == ''
  end

  def display_error_message
    puts error.inspect
  end
end