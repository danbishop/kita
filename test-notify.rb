#!/usr/bin/ruby

require 'gir_ffi'

GirFFI.setup :Notify

# Both Gtk and Notify need to be init'ed.
Notify.init 'notification test'

# Basic set up of the notification.
nf = Notify::Notification.new 'Hello!', 'Hi there.', '/home/dan/logos.svg'
nf.timeout = 3000
nf.urgency = :critical

# Show a button 'Test' in the notification, with a callback function.
nf.add_action('test', 'Test') do |_obj, action, _user_data|
  puts "Action #{action} clicked."
end

# Show a button 'Test' in the notification, with a callback function.
nf.add_action('snooze', 'Snooze') do |_obj, action, _user_data|
  puts "Action #{action} clicked."
end

# In this case, we want the program to end once the notification is gone,
# but not before.
nf.signal_connect('closed') do
  puts 'Notification closed.'
  Gtk.main_quit
end

# Show the notification.
nf.show
