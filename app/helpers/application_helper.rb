module ApplicationHelper
  def body_painted_if_devise
    is_included = %w[sessions registrations].include?(controller.controller_name)
    is_not_edit = controller.action_name != 'edit'

    if is_included && is_not_edit
      "<body class='full-black'>".html_safe
    else
      '<body'.html_safe
    end
  end

  def navigation_if_logged
    return unless user_signed_in?

    render(partial: 'layouts/navigation')
  end
end
