# frozen_string_literal: true

require 'gst'

# Initialise Gstreamer for sounds
class Audio
  def initialize
    setup_gst
  end

  def setup_gst
    Gst.init
    @playbin = Gst::ElementFactory.make('playbin3')

    @playbin.bus.add_watch do |_bus, message|
      case message.type
      when Gst::MessageType::EOS
        @playbin.stop
      end
    end
  end

  def play(uri)
    @playbin.stop
    p @playbin.uri = Gst.filename_to_uri("#{RootPath}/sounds/#{uri}.ogg")
    @playbin.play
  end

  def repeat
    @playbin.stop
    @playbin.play
  end
end
