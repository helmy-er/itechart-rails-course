# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence('email') { |i| "joe#{i}@joe" }
    password '1111111'
  end
  factory :expense do
    name 'Jhon'
    association(:category)
  end
  factory :person do
    name 'jhon'
    association(:user)
  end
  factory :category do
    name 'first_category'
  end
  factory :buffer do
    person_id 1
    category_id 1
  end
end
