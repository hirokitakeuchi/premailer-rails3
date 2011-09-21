module PremailerRails
  class Hook
    def self.delivering_email(message)
      
      doc = Hpricot(message.html_part.body.to_s)
      
      # Pull out html head
      head = (Hpricot(message.html_part.body.to_s)/"head").to_html
      
      # Convert html part of the message (extracting head first)
      doc.at("head").swap("<head></head>") #Doc now has an empty head
      html_part = Premailer.new(doc.to_s)
      
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
        processed_doc = Hpricot(html_part.to_inline_css.to_s)
        processed_doc.at("head").swap(head.to_s) # swapping head back in
        body processed_doc.to_html
      end

      message.text_part do
        content_type "text/plain; charset=#{charset}"
        body text_part
      end
            
    end
  end
end