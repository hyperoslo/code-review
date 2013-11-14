require "sinatra"

helpers do
  def format_commit_message message
    paragraphs = message.split "\n\n"

    paragraphs[0] = "<strong class=\"action\">#{paragraphs.first}</strong>"

    message = paragraphs.join "\n\n"
    message = message.gsub "\n", "<br />"

    message
  end
end
