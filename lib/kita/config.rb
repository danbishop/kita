# frozen_string_literal: true

require 'config'
require 'fileutils'

# Set config directory and create it if it doesn't exist
CONF_DIR = "#{ENV['HOME']}/.config/kita"
CONF_FILE = "#{CONF_DIR}/config.yaml"
FileUtils.mkdir_p(CONF_DIR) unless File.exist?(CONF_DIR)

def save_settings
  puts 'Saved settings'
  File.open(CONF_FILE, 'w') { |file| file.write(Settings.to_hash.to_yaml) }
end

if File.exist?(CONF_FILE)
  puts 'Loaded settings'
  Config.load_and_set_settings(CONF_FILE)
else
  puts 'No settings detected, first run? Using defaults.'
  Config.load_and_set_settings(CONF_FILE)
  Settings.speak = true
  Settings.hiragana = true
  Settings.katakana = false
  save_settings
end
