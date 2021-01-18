FactoryBot.define do
  factory :person do
    first_name { "Christmas" }
    last_name { "Zaddy" }
    is_current_host { true }
    is_former_host { false }

    trait :guest do
      is_current_host {false}
      is_former_host {false}
    end

    trait :former_host do
      is_current_host {false}
      is_former_host {true}
    end
  end
end