require 'rails_helper'

RSpec.describe Good, type: :model do
  
  context 'validation tests' do
    it 'ensures name is present' do
    good= Good.new(price:12345.12).save
      expect(good).to equal(false)
    end

    it 'ensures price is present' do
      good= Good.new(name:"Just name").save
      expect(good).to equal(false)
    end

    it 'should save successfully' do
      good= Good.new(name:"Good",price:12345.12).save
      expect(good).to equal(true)
    end
  end

end
