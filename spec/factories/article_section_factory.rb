FactoryBot.define do
  factory :article_section do
    article
    seq 0
    description_markdown '### Some markdown'
    section { FFaker::Lorem.sentence(4) }
  end
end
