# frozen_string_literal: true

class Intrest < ApplicationRecord
  belongs_to :user
  belongs_to :tag
end
