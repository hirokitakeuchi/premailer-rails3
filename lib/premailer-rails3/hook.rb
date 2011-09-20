module PremailerRails
  class Hook
    def self.delivering_email(message)
      # If mail has a text part then preserve it
      
      if message.text_part
        text_part = message.text_part.body.to_s
      end
      # If the mail only has one part, it may be stored in message.body. In that
      # case, if the mail content type is text/html, the body part will be the
      # html body.
      if message.html_part
        html_body = message.html_part.body.to_s
      elsif message.content_type =~ /text\/html/
        html_body = message.body.to_s
      end
      
      message.body = nil

      premailer = Premailer.new(html_body)
      charset   = message.charset
      text_part = premailer.to_plain_text unless text_part
      
      message.html_part do
        content_type "text/html; charset=#{charset}"
        body premailer.to_inline_css
      end

      message.text_part do
        content_type "text/plain; charset=#{charset}"
        body text_part
      end
      
    end
  end
end