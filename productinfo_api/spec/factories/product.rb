FactoryGirl.define do
  factory :product_hoge_fuga,class: Product do
    name "hogehoge"
    text "fugafuga"
    factory :product_hoge_fuga_100,class: Product do
      cost 100
    end
    factory :product_hoge_fuga_1000,class: Product do
      cost 1000
    end
    factory :product_hoge_fuga_10000,class: Product do
      cost 10000
    end
  end
  factory :product_hoge_hoge,class: Product do
    name "hogehoge"
    text "hogehoge"
    factory :product_hoge_hoge_100,class: Product do
      cost 100
    end
    factory :product_hoge_hoge_1000,class: Product do
      cost 1000
    end
    factory :product_hoge_hoge_10000,class: Product do
      cost 10000
    end
  end
  factory :product_fuga_fuga,class: Product do
    name "fugafuga"
    text "fugafuga"
    factory :product_fuga_fuga_100,class: Product do
      cost 100
    end
    factory :product_fuga_fuga_1000,class: Product do
      cost 1000
    end
    factory :product_fuga_fuga_10000,class: Product do
      cost 10000
    end
  end
end
