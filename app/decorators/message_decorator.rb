# frozen_string_literal: true

class MessageDecorator < ApplicationDecorator
  delegate_all
  decorates :message

  def chat_indentation
    if model.user == h.current_user
      h.content_tag :div, model.body, class: 'uk-border-rounded uk-card uk-card-body uk-card-primary uk-padding-small uk-padding-remove-bottom uk-padding-remove-top uk-align-right uk-margin-small-right', style: 'word-wrap: break-word; max-width: 60%; display: block;'
    else
      model.update_attributes(read: true) unless model.read?
      h.content_tag :div, model.body, class: 'uk-border-rounded uk-card uk-card-body uk-card-default uk-padding-small uk-padding-remove-bottom uk-padding-remove-top uk-align-left uk-margin-small-left', style: 'word-wrap: break-word; max-width: 60%; display: block;'
    end
  end
end
