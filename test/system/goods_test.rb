require "application_system_test_case"

class GoodsTest < ApplicationSystemTestCase

  setup do
    30.times do
      create(:good)
    end
    create(:user)
  end


  test "visiting the index" do
    
    visit (goods_path)
    click_on "Bejelentkezés"  
    fill_in "user_email", with: "user@gmail.com"
    fill_in "user_password", with: "secret"
    click_on "Log in"
    
    assert_current_path(root_path)
  end
end
