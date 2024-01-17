FactoryBot.define do
  factory :metric do
    # Define attributes for your Unit model
    name { Faker::Name.unique.name }
    description {Faker::Lorem.word }
    series_color {Faker::Color.hex_color}
    series_type {['metric','event'].sample}
    unit
    # Add other attributes as needed
  end
end