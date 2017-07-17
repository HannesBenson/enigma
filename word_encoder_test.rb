# frozen_string_literal: true

require_relative 'word_encoder'
require 'minitest/autorun'
require 'maxitest/autorun'

describe 'WordEncoder' do
  context '#encode_string' do
    context 'when the file does NOT exist' do
      it 'displays an error message' do
        path_that_does_not_exist = '/path/does/not/exist'
        expected_error = "The file '/path/does/not/exist' does not exist!\n"
        proc { WordEncoder.encode_string_or_file(path_that_does_not_exist) }.must_output expected_error
      end
    end

    context 'when the file does exist' do
      it 'encode the contents of the file' do
        actual_path = File.join(File.dirname(__FILE__), 'test_data.txt')
        expected_string = "4|1|1A2|1A2|C\n2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1\n"
        proc { WordEncoder.encode_string_or_file(actual_path) }.must_output expected_string
      end
    end

    context 'when passing in an empty string' do
      it 'displays an error message' do
        expected_error = "You cannot encode an empty message!\n"
        proc { WordEncoder.encode_string_or_file('') }.must_output expected_error
      end
    end

    context 'when passing in a valid string' do
      it 'encodes the message correctly' do
        string = 'I AM IN  TROUBLE'
        expected_string = "2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1\n"
        proc { WordEncoder.encode_string_or_file(string) }.must_output expected_string
      end
    end
  end
end
