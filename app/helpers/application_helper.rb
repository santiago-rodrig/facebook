module ApplicationHelper
  def body_painted_if_devise(name, action)
    is_included = %w[sessions registrations].include?(name)
    is_not_edit = action != 'edit'

    if is_included && is_not_edit
      "<body class='full-black'>".html_safe
    else
      '<body>'.html_safe
    end
  end

  def navigation_if_logged(is_logged)
    return unless is_logged

    render(partial: 'layouts/navigation')
  end
end
