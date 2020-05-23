# frozen_string_literal: true

require 'gtk3'

# Require all ruby files in the application folder recursively
# TODO: Improve this
application_root_path = File.expand_path(__dir__)
Dir[File.join(application_root_path, 'lib', '*.rb')].sort.each do |file|
  require file
end

Dir[File.join(application_root_path, 'ui', '*.rb')].sort.each do |file|
  require file
end

app = Kita::Application.new

app.run

Gtk.main
