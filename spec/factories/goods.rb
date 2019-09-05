FactoryBot.define do
  factory :good do
    name {"Test good"}
    category_id { 1 }
    description{ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac sagittis metus. Etiam id felis quis nulla elementum accumsan at fringilla lacus. Proin tempus iaculis feugiat. Proin consequat diam diam, vel dignissim mi semper ut. Nulla facilisi. Sed molestie mauris at ipsum maximus pulvinar. Ut consequat eu lacus at ultrices. Curabitur consequat et dolor vel pretium. Proin ac fringilla nunc, sit amet consectetur dolor. Suspendisse tortor lacus, pellentesque tempus ipsum id, molestie dignissim metus. Donec placerat tellus augue, eget maximus orci placerat pulvinar." }
    number { 3 }
    seller_id { User.first.id }
    price { 2000 }
  end
end
