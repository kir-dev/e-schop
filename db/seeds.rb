require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
categories = Category.create!([
    { name: 'Étel'},
    { name: 'Ital'},
    { name: 'Egyéb'}
])

10.times do |good|
good= Good.create(
    name:Faker::Name.name,
    price:Faker::Number.between(100, 10000),
    description:Faker::Lorem.paragraph(2),
    number: rand(0...10),
    category_id: rand(0...2),
    seller_id:1,
    product_id:1
)
product =Product.create(
    name:good.name, 
    category_id:good.category_id
)
downloaded_image = open("http://lorempixel.com/400/400/food/")
    product.photo.attach(io: downloaded_image  , filename: "foo.jpg")
    
good.product_id=product.id
good.save
puts "XXXXXXXXXXXXXXXXXXXXXXXX"
    puts product.id
    puts good.product_id

end
