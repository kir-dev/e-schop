require 'rails_helper'

RSpec.describe Good, type: :model do
  context 'validation tests' do
    it 'validate name presence' do
      good = Good.new(price:1000).save
      expect(good).to eq(false)
    end
    it 'validate price presece' do
      good = Good.new(name:"Keksz").save
      expect(good).to eq(false)
    end
    it 'validate price is a number' do
      good = Good.new(name:"Keksz",price:"nemegyszam").save
      expect(good).to eq(false)
    end
    it 'should save' do
      good = Good.new(name:"Keksz",price:1000).save
      expect(good).to eq(true)
    end
    
  end
end
