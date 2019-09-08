# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def check_good_id
    if Good.with_deleted.find_by_id(params[:id]).nil?
      redirect_to action: 'landing', controller: 'goods'
    end
  end
end
