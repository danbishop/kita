# frozen_string_literal: true

require 'config'

Config.load_and_set_settings(Config.setting_files('~/kita.yaml', 'kita'))
Settings.speak = true
Settings.hiragana = true
Settings.katakana = false
