# frozen_string_literal: true

require_relative 'hiragana'
require_relative 'katakana'

# Question Class
class Question
  attr_accessor :type

  def initialize
    @hiragana = Hiragana.new
    @katakana = Katakana.new
  end

  def new_question
    question_types = []
    question_types.push @hiragana if Settings.hiragana
    question_types.push @katakana if Settings.katakana
    question = question_types.sample.question
    @type = question[:type]
    question
  end
end
