# frozen_string_literal: true

# Menu Related Functions
module Menu
  def menu_load
    puts 'Setting up menu'
    @builder['hiragana_switch'].set_active(Settings.hiragana)
    @builder['katakana_switch'].set_active(Settings.katakana)
    @builder['sound_switch'].set_active(Settings.sound)
  end
end
