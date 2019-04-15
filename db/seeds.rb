# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


users = User.create!([{ username: 'Ákos',password: '12345678',roomnumber: -1 },
{ username: 'Bálint',password: '43210',roomnumber: 704 },
{ username: 'Csabi',password: '10203',roomnumber: 2019 },
{ username: 'Laci',password: '1234',roomnumber: 713 }])

goods = Good.create!([{ name: 'Kakaós csiga', price:200, description:'Banánnal nagyon jó!',category_id:1,seller_id:1 },
{ name: 'Banán', price:145, description:'Egészséges és illik a kakaós csigához.',category_id:1,seller_id:1 },
{ name: 'Bomba gól', price:1, description:'Nem lehet kivédeni + csalás.',category_id:3,seller_id:2 },
{ name: 'Anna kenyér', price:330, description:'A legjobb kenyér <3',category_id:1,seller_id:3 }
])

categories = Category.create!([
    { name: 'Étel'},
    { name: 'Ital'},
    { name: 'Egyéb'}    
])