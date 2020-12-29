FactoryBot.define do
  factory :person do
    first_name { "Greg" }
    last_name { "Cobb" }
    guest { false }
  end
end