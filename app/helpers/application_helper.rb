module ApplicationHelper

  def build_status build
    css_class = 'label'
    css_class << ' label-green' if build.success?
    css_class << ' label-red' if build.fail?
    css_class << ' label-yellow' if build.in_progress?

    content_tag(:div, build.status.humanize, class: css_class)
  end

end
