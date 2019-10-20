# frozen_string_literal: true

class GoodDecorator < ApplicationDecorator
  delegate_all
  decorates :good

  def list(conversation); end
end
