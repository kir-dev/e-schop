FactoryBot.define do
    factory :user do
        id {1}
        email {"user@gmail.com"}
        password{'secret'}
        username{'User'}
        roomnumber {'707'}
      
    end
  end