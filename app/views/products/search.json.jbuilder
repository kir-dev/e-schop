
json.array!(@tags) do |tag|
    json.name tag.name
end
    json.array!(@products) do |product|
      json.name product.name
    
    end
  