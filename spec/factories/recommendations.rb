FactoryBot.define do
  factory :recommendation do
    episode
    person
    name { "Dr. Doolittle" }
  end
end