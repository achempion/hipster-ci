module ApplicationHelper

  def build_status build
    css_class = 'build-label'
    css_class << ' build-label-green' if build.success?
    css_class << ' build-label-red' if build.fail?
    css_class << ' build-label-yellow' if build.in_progress?

    spinner = content_tag(:span, content_tag(:i, nil, class: 'fa fa-circle-o-notch fa-spin'), class: 'build-item_spin-wrapper')
    status = content_tag(:div, build.status.humanize, class: css_class)

    build.in_progress? ? spinner + status : status
  end

end
