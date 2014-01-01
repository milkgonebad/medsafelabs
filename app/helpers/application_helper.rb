module ApplicationHelper
  
  def display_errors(errors)
    if errors.any?
      out = '<div id="error_explanation"><ul>'
      errors.full_messages.each do |msg|
        out << '<li>' + msg + '</li>'
      end
      out << '</ul></div>'
      raw out
    end
  end
  
end
