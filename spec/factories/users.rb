# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@gmail.com' }
    password { 'secret' }
    username { 'User' }
    roomnumber { '707' }
  end
end
