module ApplicationHelper

  def comments_form_url(report, comment)
    if comment.new_record?
      "/reports/#{report.id}/comments"
    else
      "/reports/#{report.id}/comments/#{comment.id}"
    end
  end

  def comments_form_class(comment)
    if comment.new_record?
      ""
    else
      "well"
    end
  end
end
