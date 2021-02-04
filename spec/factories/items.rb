# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    title
    sequence(:position) { |n| n.alph }
  end
end
