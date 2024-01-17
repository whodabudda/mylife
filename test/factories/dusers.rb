# test/factories/dusers.rb
FactoryBot.define do
  factory :duser do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    username { Faker::Internet.username }
    #association :unit, factory: :unit
    # You can add associations here if needed
    # duser_roles { association(:duser_role) }
    # duser_metrics { association(:duser_metric) }
    # roles { association(:role) }
    # units { association(:unit) }
    # reviews { association(:review) }

   trait :with_specific_id do 
      transient do
        specific_id { nil }
      end
      initialize_with { new(attributes) { |d| d.id = specific_id } }
    end

    trait :not_unique do
      email { 'address@nomail.com' }
      username { 'joetheuser' }
    end
  end
end
