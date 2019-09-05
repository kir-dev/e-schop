require 'rails_helper'

RSpec.feature "Users", type: :feature do

  setup do
    create(:user)
    30.times do
      create(:good)
    end
  end


  it 'Check login' do
    visit (goods_path)

    within find('#topbar') do
      click_on "Bejelentkezés"  
    end
    
    fill_in "user_email", with: "user@gmail.com"
    fill_in "user_password", with: "secret"
    click_on "Log in"
    
    assert_current_path(root_path)
  end
end
