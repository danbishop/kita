# frozen_string_literal: true
require 'gtk3'
require_relative 'kita/audio'
require_relative 'kita/config'
require_relative 'kita/hiragana'
require_relative 'kita/katakana'
require_relative 'kita/version'

module Kita
  # Main application class
  class Application < Gtk::Application
    def initialize
      super 'uk.danbishop.kita', :handles_open
      builder_file = "#{File.expand_path(File.dirname(__dir__))}/ui/builder.ui"
      # Construct a Gtk::Builder instance and load our UI description
      @builder = Gtk::Builder.new(file: builder_file)
      # Initiate Hiragana class
      @hiragana = Hiragana.new
      # Initiate Katakana class
      @katakana = Katakana.new
      @types = [@hiragana]
      @button_signals = {}
      @sound = Audio.new
      new_question
      menu_setup
      setup_new_question_button
      setup_repeat_button
      build_main_window
    end

    def menu_setup
      setup_hiragana_switch
      setup_katakana_switch
      setup_sound_switch
      setup_about_box
    end

    def setup_about_box
      about_box = @builder.get_object('about_box')
      about_button = @builder.get_object('menu_about')
      about_button.signal_connect('clicked') do
        about_box.run
        about_box.hide
      end
    end

    def setup_new_question_button
      new_question_button = @builder.get_object('new_question')
      new_question_button.signal_connect('clicked') do
        new_question
      end
    end

    def setup_repeat_button
      new_question_button = @builder.get_object('speak')
      new_question_button.signal_connect('clicked') do
        @sound.repeat
      end
    end

    def setup_hiragana_switch
      @hiragana_switch = @builder.get_object('hiragana_switch')
      @hiragana_switch.signal_connect('notify::active') do
        toggle_hiragana
      end
    end

    def setup_katakana_switch
      @katakana_switch = @builder.get_object('katakana_switch')
      @katakana_switch.signal_connect('notify::active') do
        toggle_katakana
      end
    end

    def setup_sound_switch
      @sound_switch = @builder.get_object('sound_switch')
      @sound_switch.signal_connect('notify::active') do
        toggle_sound
      end
    end

    def toggle_katakana
      # TODO: Switch this to using Settings
      @types = []
      @types << @hiragana if @hiragana_switch.active?
      @types << @katakana if @katakana_switch.active?
      (@hiragana_switch.set_active(true) && @types = [@hiragana]) if @types.empty?
    end

    def toggle_hiragana
      # TODO: Switch this to using Settings
      @types = []
      @types << @hiragana if @hiragana_switch.active?
      @types << @katakana if @katakana_switch.active?
      (@katakana_switch.set_active(true) && @types = [@katakana]) if @types.empty?
    end

    def toggle_sound
      Settings.speak = !Settings.speak
    end

    def build_main_window
      signal_connect :activate do
        # Connect signal handlers to the constructed widgets
        window = @builder.get_object('window')
        window.signal_connect('destroy') { Gtk.main_quit }
        window.present
      end
    end

    def new_question
      reset_buttons
      question = @types.sample.question
      question_label = @builder.get_object('question')
      question_label.set_markup("<span font='72'>#{question[:question]}</span>")
      buttons = %w[a b c d]
      correct_button(buttons, question)
      wrong_buttons(buttons, question)
      puts "Playing: #{question[:question].hiragana}"
      @sound.play(question[:question].hiragana) if Settings.speak
    end

    def correct_button(buttons, question)
      # Choose random letter and remove it from array
      correct = buttons.delete(buttons.sample)
      correct_button = @builder.get_object("answer_#{correct}")
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
      label.set_markup("<span color='#d40000'>#{button.label} #{button.label.hiragana}</span>")
    end

    def reset_buttons
      return nil if @button_signals.empty?

      @button_signals.each do |letter, signal|
        button = @builder.get_object("answer_#{letter}")
        button.signal_handler_disconnect(signal)
        button.set_sensitive(true)
      end
      @button_signals = {}
    end
  end
end
