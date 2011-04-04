module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Sovonex International"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # Site logo image tag
  def logo
    image_tag("logo.png", :alt => "sample app", :class => "round")
  end
end



