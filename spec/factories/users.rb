FactoryBot.define do
  factory :user do
    email { "user_#{SecureRandom.hex(10)}@capsens.eu" }
    first_name { "John" }
    last_name { "Doe" }
    password { 'Password1' }
  end
end
