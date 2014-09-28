sequence = Enumerator.new do |yielder|
  number = 0
  loop do
    number += 1
    yielder.yield number
  end
end

FactoryGirl.define do
  factory :project do
    path { "factory-project/#{sequence.next}" }
    access_token { "access-token-#{sequence.next}" }
  end

  factory :build do
    project { create(:project) }
    sha { "sha-of-commit-#{sequence.next}" }
  end
end