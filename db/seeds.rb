# frozen_string_literal: true

require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
categories = Category.create!([
                                { name: 'Étel' },
                                { name: 'Ital' },
                                { name: 'Egyéb' }
                              ])

users = User.create!([
                       { email: 'user@gmail.com', password: '123456', username: 'User' },
                       { email: 'client@gmail.com', password: '123456', username: 'Client' },
                       { email: 'tester@gmail.com', password: '123456', username: 'Tester' }
                     ])

tags = Tag.create!([
                          { name: 'Étel', category: true, number: 0 },
                          { name: 'Ital', category: true, number: 0 },
                          { name: 'Egyéb', category: true, number: 0 }
                        ])

tagnumber = 10
tagnumber.times do
  Tag.create!(name: Faker::Food.unique.ingredient, category: false, number: 0)
end

levelnumber = 20

number_ = 1
levelnumber.times do
  Level.create!( number: number_, good_number: 0 )
  number_ += 1
end

puts 'seeding goods:'
seednumber = 30
seednumber.times do |good|
  good = Good.create(
    name: Faker::Food.unique.dish,
    price: Faker::Number.between(100, 10_000),
    description: Faker::Lorem.paragraph(4),
    number: rand(1...10),
    seller_id: 1,
    product_id: 1
  )
  tag = Tag.find(rand(1..3))
  tag.number += 1
  good.tags << tag
  tag = Tag.find(rand(4...tagnumber + 3))
  tag.number += 1
  good.tags << tag

  product = Product.create(
    name: good.name,
    tags: good.tags
  )

  #     image = open("https://source.unsplash.com/featured/?food")
  image = File.open("./seedimages/image#{good.id}.jpg", 'rb')
  product.photo.attach(io: image, filename: 'foo.jpg')

  good.product_id = product.id

  good.save
  product.save

  puts "#{product.id}/#{seednumber}"


end
