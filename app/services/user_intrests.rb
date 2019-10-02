# frozen_string_literal: true

class UserIntrests
  def initialize(user)
    @user = user
  end

  def add_good_tags(good)
    good.tags.each do |tag|
      intrest_in_tag = @user.intrests.find { |intrest| intrest.tag == tag }
      if intrest_in_tag.nil?
        new_intrest = @user.intrests.create(rate: 1)
        new_intrest.tag = tag
        new_intrest.save
      else
        intrest_in_tag.rate += 1
        intrest_in_tag.save
      end
    end
    end

  def add_good_tags_from_params(good)
    return if good.nil?

    selected_tags = params[:selected_tags].split('#')

    tags = Tag.all
    selected_tags.each do |tag|
      if tags.any? { |t| t.name == tag }
        good.tags << tags.find { |t| t.name == tag }
      else
        new_tag = Tag.create(name: tag)
        good.tags << new_tag
      end
    end
  end
end
