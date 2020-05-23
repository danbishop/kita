# frozen_string_literal: true

require 'mojinizer'

HIRAGANA = %w[
  あ い う え お
  か き く け こ
  が ぎ ぐ げ ご
  さ し す せ そ
  ざ じ ず ぜ ぞ
  た ち つ て と
  だ ぢ づ で ど
  な に ぬ ね の
  は ひ ふ へ ほ
  ば び ぶ べ ぼ
  ぱ ぴ ぷ ぺ ぽ
  ま み む め も
  や ゆ よ
  ら り る れ ろ
  わ を
  ん
].freeze

# Hiragana Class
class Hiragana
  def initialize
    @previous = []
  end

  def question
    # Keep selecting a new character at random until it's
    # different to any in the 'previous' array
    chars = HIRAGANA.sample(4)
    chars = HIRAGANA.sample(4) while @previous.include? chars[0]
    question = build_question(chars)
    # Log character to ensure no character from the last 10 is repeated
    log_character(chars[0])
    question
  end

  private

  def log_character(character)
    @previous.shift if @previous.size > 9
    @previous.push character
  end

  def build_question(chars)
    {
      question: chars[0],
      answer: chars[0].romaji,
      choices: [
        chars[1].romaji,
        chars[2].romaji,
        chars[3].romaji
      ]
    }
  end
end
