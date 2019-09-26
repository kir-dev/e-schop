# frozen_string_literal: true

json.goods do
  json.array!(@goods) do |good|
    json.name good.name
    json.url good_path(good)
    json.image url_for(get_image(good,"cart"))
    json.price good.price
  end
end
json.tags do
  json.array!(@tags) do |tag|
    json.name tag.name
    json.url "/tags/#{tag.id}"
    json.image asset_url ("empty.png")
  end
end
