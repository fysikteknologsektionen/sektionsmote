# frozen_string_literal: true

FactoryBot.define do
  factory :sub_item do
    item
    title
    sequence(:position) { |n| n }
  end
end
