# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :goods
  has_many :records
end
