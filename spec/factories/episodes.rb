FactoryBot.define do
  factory :episode do
    sequence(:number) { |n| n }
    title { "A Very Special Episode" }
  end
end