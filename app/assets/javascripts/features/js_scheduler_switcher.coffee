$ ->
  $('.js-scheduler-switcher').off('change').change ->
    is_checked = $(@).is(':checked')
    if is_checked
      $.ajax '/scheduler',
        type: 'POST'
    else
      $.ajax '/scheduler',
        type: 'DELETE'
