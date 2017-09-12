FactoryGirl.define do
  factory :store do
    name "test"
  end
  factory :store_hoge,class: Store do
    name "hogehoge"
  end
  factory :store_fuga,class: Store do
    name "fugafuga"
  end
end
