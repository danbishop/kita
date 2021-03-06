# frozen_string_literal: true

require 'gtk3'
require 'fast_gettext'
require_relative 'kita/audio'
require_relative 'kita/config'
# require_relative 'kita/locale'
require_relative 'kita/menu'
require_relative 'kita/question'
require_relative 'kita/version'

# Main Kita Module
module Kita
  # LocaleSettings.new
  # Main application class
  class Application < Gtk::Application
    include Menu

    def initialize
      super 'uk.danbishop.kita', :handles_open
      # Construct a Gtk::Builder instance
      @builder = Gtk::Builder.new(file: "#{File.expand_path(File.dirname(__dir__))}/ui/builder.ui")
      # Set menu toggles to match settings
      menu_load
      # Now connect signals
      @builder.connect_signals { |handler| method(handler) }
      # Initiate Question class
      @question = Question.new
      @button_signals = {}
      @sound = Audio.new
      new_question
      setup_about_box
      build_main_window
    end

    def setup_about_box
      @ee = 0
      about_box = @builder['about_box']
      about_box.version = VERSION
      @builder['menu_about'].signal_connect('clicked') do
        about_box.run
        about_box.hide
      end
    end

    def repeat_button_click
      @sound.repeat
    end

    def toggle_katakana
      Settings.katakana = !Settings.katakana
      (@builder['hiragana_switch'].set_active(true) && Settings.hiragana = true) if !Settings.katakana && !Settings.hiragana
      save_settings
    end

    def toggle_hiragana
      Settings.hiragana = !Settings.hiragana
      (@builder['katakana_switch'].set_active(true) && Settings.katakana = true) if !Settings.katakana && !Settings.hiragana
      save_settings
    end

    def toggle_sound
      Settings.sound = !Settings.sound
      save_settings
    end

    def ee
      @ee += 1
      @sound.play('これは北です') if @ee == 3
    end

    def build_main_window
      signal_connect :activate do
        # Connect signal handlers to the constructed widgets
        window = @builder['window']
        window.signal_connect('destroy') { Gtk.main_quit }
        window.present
      end
    end

    def new_question
      reset_buttons
      question = @question.new_question
      @builder['question'].set_markup("<span font='72'>#{question[:question]}</span>")
      buttons = %w[a b c d]
      correct_button(buttons, question)
      wrong_buttons(buttons, question)
      @sound.play("#{question[:question].hiragana}#{[1, 2].sample}") if Settings.sound
    end

    def correct_button(buttons, question)
      # Choose random letter and remove it from array
      correct = buttons.delete(buttons.sample)
      correct_button = @builder["answer_#{correct}"]
      correct_button.set_label(question[:answer])
      correct_signal = correct_button.signal_connect('clicked') do
        new_question
      end
      @button_signals[correct] = correct_signal
    end

    def wrong_buttons(buttons, question)
      buttons.each_with_index do |letter, i|
        button = @builder.get_object("answer_#{letter}")
        button.set_label(question[:choices][i])
        signal = button.signal_connect('clicked') { wrong_button_click(button) }
        @button_signals[letter] = signal
      end
    end

    def wrong_button_click(button)
      button.set_sensitive(false)
      label = button.child
      correction = @question.type == 'hiragana' ? button.label.hiragana : button.label.katakana
      label.set_markup(
        "<span color='#d40000'>#{button.label} #{correction}</span>"
      )
    end

    def reset_buttons
      return nil if @button_signals.empty?

      @button_signals.each do |letter, signal|
        button = @builder["answer_#{letter}"]
        button.signal_handler_disconnect(signal)
        button.set_sensitive(true)
      end
      @button_signals = {}
    end
  end
end
