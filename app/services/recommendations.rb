# frozen_string_literal: true

class Recommendations
  def initialize(user)
    @user = user
  end

  def get_recommendations_from(goods)
    recommendations_count = 9
    recommendation_per_tag_number = 2

    recommendations = []
    user_favourite_tags.each do |tag|
      recommendations_per_tag = goods.select { |good| good.tags.include?(tag) && !recommendations.include?(good) }
      recommendations_per_tag = recommendations_per_tag.first(2)

      recommendations_count -= recommendations_per_tag.size
      recommendations_per_tag.each do |rec|
        recommendations.push(rec)
      end
    end
    recommendations_from_other = Good.limit(recommendations_count).select { |good| !good.tags.include?(user_favourite_tags) && !recommendations.include?(good) }
    recommendations_from_other.each do |rec|
      recommendations.push(rec)
    end
    recommendations
    end

  def user_favourite_tags
    top_intrests = @user.intrests.order(rate: :desc).limit(3)
    favourite_tags = []
    top_intrests.each do |intrest|
      favourite_tags.push(intrest.tag)
    end
    favourite_tags
  end

  def total_intrest_rate_in_tag(tag)
    total_intrest_rate = 0

    User.all.each do |user|
      user_intrest = user.intrests.find { |intrest| intrest.tag == tag }
      total_intrest_rate += user_intrest.rate unless user_intrest.nil?
    end

    total_intrest_rate
  end
end
