# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoodsController, type: :controller do
  context 'response tests' do
    it 'GET #index' do
      get :index
      @user = create(:user)
      sign_in @user
      expect(response).to be_successful
    end
  end
end
