require 'rails_helper'

RSpec.describe GoodsController, type: :controller do
    before(:each) do
        sign_in :one
    end
    context 'GET #index' do
        it 'returns a successful response' do
            get :index
            expect(response).to be_successful
        end
    end
    context 'GET #show' do
        it 'returns a successful response' do
            get :show, params:{id:Good.first.id}
            expect(response).to be_successful
        end
    end
end
