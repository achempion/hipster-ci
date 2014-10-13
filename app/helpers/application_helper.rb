module ApplicationHelper

  def build_status build
    css_class = 'build-label'
    css_class << ' build-label-green' if build.success?
    css_class << ' build-label-red' if build.fail?
    css_class << ' build-label-yellow' if build.in_progress?

    content_tag(:div, build.status.humanize, class: css_class)
  end

end
