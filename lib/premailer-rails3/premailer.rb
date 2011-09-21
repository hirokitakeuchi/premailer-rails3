module PremailerRails
  class Premailer < ::Premailer
    @@_css_cache = {}

    def initialize(html)
      load_html(html)
      options = {
        :with_html_string => true,
        :adapter          => :hpricot,
        :css              => ['public/stylesheets/email.css']
      }
      super(html, options)
    end

    def load_html(string)
      # @doc is also used by ::Premailer
      @doc ||= Hpricot(string)
    end

    protected

    # def default_css_file
    #   # Don't cache in development.
    #   if Rails.env.development? or not @@_css_cache.include? :default
    #     if Rails.configuration.try(:assets).try(:enabled)
    #       @@_css_cache[:default] = Rails.application.assets.find_asset('email.css').body
    #     else
    #       @@_css_cache[:default] = File.read('public/stylesheets/email.css')
    #     end
    #   end
    #   @@_css_cache[:default]
    # rescue => ex
    #   puts ex.message
    #   @@_css_cache[:default] = nil
    # end

    # Scan the HTML mailer template for CSS files, specifically link tags with
    # types of text/css (other ways of including CSS are not supported).
#    def linked_css_files
#      @_linked_css_files ||= @doc.search('link[@type="text/css"]').collect do |l|
#        href = l.attributes['href']
#        if href.include? '?'
#          href[0..(href.index('?') - 1)]
#        else
#          href
#        end
#      end
#    end
  end
end
