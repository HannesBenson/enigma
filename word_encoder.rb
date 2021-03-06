# frozen_string_literal: true

class WordEncoder
  MORSE_MAP = { 'A' => '.-', 'B' => '-...', 'C' => '-.-.', 'D' => '-..', 'E' => '.', 'F' => '..-.', 'G' => '--.',
                'H' => '....', 'I' => '..', 'J' => '.---', 'K' => '-.-', 'L' => '.-..', 'M' => '--', 'N' => '-.',
                'O' => '---', 'P' => '.--.', 'Q' => '--.-', 'R' => '.-.', 'S' => '...', 'T' => '-', 'U' => '..-',
                'V' => '...-', 'W' => '.--', 'X' => '-..-', 'Y' => '-.--', 'Z' => '--..', '0' => '-----',
                '1' => '.----', '2' => '..---', '3' => '...--', '4' => '....-', '5' => '.....', '6' => '-....',
                '7' => '--...', '8' => '---..', '9' => '----.', '.' => '.-.-.-', ',' => '--..--' }.freeze

  def self.encode_string_or_file(string_or_path)
    new(string_or_path).process_string
  end

  def initialize(string_or_path)
    @string = read_string_from_file(string_or_path) if looks_like_path?(string_or_path)
    @string ||= read_string_from_stdin
  end

  def process_string
    validate_string
    return display_error_message if error
    encode_string
    write_encoded_message_to_file(encoded_string)
    display_success_message
  end

private

  attr_reader :string, :error, :encoded_string

  def encode_string
    @encoded_string = string.split(/\n/).map do |line|
      encode_line(line.strip)
    end.join("\n")
  end

  def display_success_message
    puts 'Message wrote to encoded_message.txt'
  end

  def read_string_from_stdin
    puts "Please enter the message you would like to have encoded:\n\n"
    STDIN.gets.chomp
  end

  def read_string_from_file(string_or_path)
    File.read(string_or_path).strip
  rescue Errno::ENOENT
    @error = "The file '#{string_or_path}' does not exist!"
  end

  def validate_string
    @error ||= 'You cannot encode an empty message!' if string_empty?
    @error ||= 'The message can only contain alphanumeric characters!' if !string_valid?
  end

  def encode_line(line)
    line.split(/\s+/).map do |word|
      convert_word_to_morse_and_encode(word)
    end.join('/')
  end

  def convert_word_to_morse_and_encode(word)
    word.scan(/\w/).map do |char|
      morse_char = MORSE_MAP[char.upcase]
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

  def string_valid?
    string.gsub(/\s+/, '').upcase.split(//) - MORSE_MAP.keys == []
  end

  def display_error_message
    puts error
  end

  def write_encoded_message_to_file(encoded_string)
    path = File.join(File.dirname(__FILE__), 'encoded_message.txt')
    File.open(path, 'w') do |f|
      f.puts encoded_string
    end
  end
end
