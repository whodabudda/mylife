FactoryBot.define do
  factory :duser_metric do
    # Define attributes for your Unit model
    value {Faker::Number.between(from: 1, to: 1000) }
    occur_dttm  {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)}
    # Add other attributes as needed
  end
end