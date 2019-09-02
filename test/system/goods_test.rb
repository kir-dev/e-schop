require "application_system_test_case"

class GoodsTest < ApplicationSystemTestCase

  test "visiting the index" do
    30.times do
      create(:good)
    end
    create(:user)

    visit (goods_path)
    expect(page).to have_current_path(goods_pathf)
    
   
  end
end
