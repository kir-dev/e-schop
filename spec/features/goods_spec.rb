# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Goods', type: :feature do
  setup do
    create(:user)
    30.times do
      create(:good)
    end
  end

  it 'check modal' do
    sign_in User.first
    visit goods_path

    within('#main') do
      page.all(:xpath, './a')[0].click
    end
  end
end
