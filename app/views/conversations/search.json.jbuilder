# frozen_string_literal: true

json.users do
  json.array!(@users) do |user|
    json.name user.name
    json.id user.id
  end
end
