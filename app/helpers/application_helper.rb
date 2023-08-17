module ApplicationHelper
  def full_title page_title = ""
    base_title = t("static_pages.full_title")
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
