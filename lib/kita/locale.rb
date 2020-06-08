module Kita
  class LocaleSettings
    def initialize
      FastGettext.add_text_domain('kita', path: File.join(RootPath, 'locale'), type: :po)
      FastGettext.text_domain = 'kita'
      FastGettext.available_locales = %w(de en)

      puts "Select locale code:"

      FastGettext.available_locales.each do |locale|
        puts locale
      end

      change_locale_to gets.strip.downcase
    end

    private

    def change_locale_to(locale)
      locale = 'en' unless FastGettext.available_locales.include?(locale)
      FastGettext.locale = locale
    end
  end
end
