# test/factories/dusers.rb
#require 'faker'


FactoryBot.define do
  factory :unit do
    # Define attributes for your Unit model
    name { Faker::Name.unique.name }
    displ_name {Faker::Lorem.word }
    # Add other attributes as needed
  end
end
