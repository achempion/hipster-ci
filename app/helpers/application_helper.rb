module ApplicationHelper

  def build_status build
    css_class = 'label'
    css_class << ' label-green' if build.success?
    css_class << ' label-red' if build.fail?

    content_tag(:div, build.status, class: css_class)
  end

end
