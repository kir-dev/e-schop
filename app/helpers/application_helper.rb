# frozen_string_literal: true

module ApplicationHelper
  def mobile?
    request.env['mobvious.device_type'].to_s == 'mobile'
  end

  def tablet?
    request.env['mobvious.device_type'].to_s == 'tablet'
  end

  def desktop?
    request.env['mobvious.device_type'].to_s == 'desktop'
  end

  def set_filename
    return unless photo.attached? && !photo.filename.to_s.eql?('photo')

    photo.blob.update_attribute(:filename, 'photo')
  end
end
