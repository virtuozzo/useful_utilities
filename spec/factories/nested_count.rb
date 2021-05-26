FactoryBot.define do
  factory :nested_count do
    association :count
    y { 3 }
  end
end

FactoryBot.define do
  factory :nested_count_child, class: NestedCountChild do
    association :count
    y { 3 }
  end
end
