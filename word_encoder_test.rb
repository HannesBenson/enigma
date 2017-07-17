# frozen_string_literal: true

require 'bundler/setup'
require_relative 'word_encoder'
require 'minitest/autorun'
require 'maxitest/autorun'
require 'mocha/test_unit'

describe WordEncoder do
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
        proc { WordEncoder.encode_string_or_file(actual_path) }.must_output success_message
      end
    end

    context 'when passing in an empty string' do
      it 'ask the user for input' do
        STDIN.expects(:gets).returns('')
        expected_error_regex = /You cannot encode an empty message!\n/
        proc { WordEncoder.encode_string_or_file('') }.must_output expected_error_regex
      end
    end

    context 'when passing in an invalid string' do
      it 'show an error message to the user' do
        STDIN.expects(:gets).returns('@#$@#$%$#@')
        expected_error_regex = /The message can only contain alphanumeric characters!\n/
        proc { WordEncoder.encode_string_or_file('') }.must_output expected_error_regex
      end
    end

    context 'when passing in a valid string' do
      it 'encodes the message correctly' do
        STDIN.expects(:gets).returns('I AM IN  TROUBLE')
        proc { WordEncoder.encode_string_or_file('') }.must_output success_message
        expected_string = "2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1\n"
        assert_equal expected_string, File.read(File.join(File.dirname(__FILE__), 'encoded_message.txt'))
      end
    end

    context 'when passing in a lower case string' do
      it 'encodes the message correctly' do
        STDIN.expects(:gets).returns('i am in  trouble')
        proc { WordEncoder.encode_string_or_file('') }.must_output success_message
        expected_string = "2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1\n"
        assert_equal expected_string, File.read(File.join(File.dirname(__FILE__), 'encoded_message.txt'))
      end
    end
  end

  private

  def success_message
    /Message wrote to encoded_message.txt/
  end
end
