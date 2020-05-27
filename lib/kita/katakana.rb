# frozen_string_literal: true

require 'mojinizer'

KATAKANA = %w[
  ア イ ウ エ オ
  カ キ ク ケ コ
  ガ ギ グ ゲ ゴ
  サ シ ス セ ソ
  ザ ジ ズ ゼ ゾ
  タ チ ツ テ ト
  ダ ヂ ヅ デ ド
  ナ ニ ヌ ネ ノ
  ハ ヒ フ ヘ ホ
  バ ビ ブ ベ ボ
  パ ピ プ ペ ポ
  マ ミ ム メ モ
  ヤ ユ ヨ
  ラ リ ル レ ロ
  ワ ヲ
  ン
].freeze

# Katakana Class
class Katakana
  def initialize
    @previous = []
  end

  def question
    # Keep selecting a new character at random until it's
    # different to any in the 'previous' array
    chars = KATAKANA.sample(4)
    chars = KATAKANA.sample(4) while @previous.include? chars[0]
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
      type: 'katakana',
      answer: chars[0].hiragana,
      choices: [
        chars[1].hiragana,
        chars[2].hiragana,
        chars[3].hiragana
      ]
    }
  end
end
