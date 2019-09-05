require 'rails_helper'

RSpec.describe User, type: :model do
  
  it 'add user from factory' do
    create(:user)
    expect(User.all.size).to eq(1)
  end
end
