# frozen_string_literal: true

json.goods do
  json.array!(@goods) do |good|
    json.name good.name
    json.url good_path(good)
  end
end
json.tags do
  json.array!(@tags) do |tag|
    json.name tag.name
    json.url "/tags/#{tag.id}"
  end
end
