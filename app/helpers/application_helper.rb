module ApplicationHelper
    def full_title page_title = ""
      base_title = t "Ruby_on_Rails_Tutorial_Sample_App"
      page_title.empty? ? base_title : page_title + " | " + base_title
    end
  end
