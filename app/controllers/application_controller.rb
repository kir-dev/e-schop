# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def check_good_id
    if Good.with_deleted.find_by_id(params[:id]).nil?
      redirect_to action: 'landing', controller: 'goods'
    end
  end

  def level_num_update(number, roomnumber)
    unless roomnumber.nil?
      level = Level.find_by_id(roomnumber / 100)
      new_num = level.good_number + number
      level.update_attributes(good_number: new_num)
    end
  end

  def tag_num_update(number, tags)
    tags.each do |t|
      new_num = t.number + number
      t.update_attributes(number: new_num)
    end
  end
end
