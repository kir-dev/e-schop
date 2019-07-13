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

puts "seeding goods:"

30.times do |good|
    good= Good.create(
        name:Faker::Food.dish,
        price:Faker::Number.between(100, 10000),
        description:Faker::Lorem.paragraph(4),
        number: rand(0...10),
        category_id: rand(1...4),
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
    product.save

    puts product.id
    

end
