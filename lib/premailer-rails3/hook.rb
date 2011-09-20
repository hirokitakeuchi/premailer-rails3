module PremailerRails
  class Hook
    def self.delivering_email(message)
      
      # Convert html part of the message

      html_part = Premailer.new(message.html_part.body.to_s)
      
      # If mail has a text part then preserve it, else convert html to text
      if message.text_part
        text_part = message.text_part.body.to_s
      else
        html_part = premailer.to_plain_text
      end
      
      # Set charset of the message
      charset = message.charset
      
      # Delete existing message
      message.body = nil
      
      # Add back html and text parts to the message
      message.html_part do
        content_type "text/html; charset=#{charset}"
        body html_part.to_inline_css
      end

      message.text_part do
        content_type "text/plain; charset=#{charset}"
        body text_part
      end
      
    end
  end
end