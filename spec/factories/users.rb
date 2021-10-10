FactoryBot.define do
  factory :user do
    trait :a do
      name                  { '管理者' }
      kana_name             { 'カンリシャ' }
      email                 { Faker::Internet.email }
      password              { Faker::Number.number(digits: 6) }
      password_confirmation { password }
      admin                 { true }
    end

    trait :b do
      name { '山田太郎' }
      kana_name { 'ヤマダタロウ' }
      email { Faker::Internet.email }
      password { Faker::Number.number(digits: 6) }
      password_confirmation { password }
    end
  end
end
