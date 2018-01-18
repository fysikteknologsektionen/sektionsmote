# frozen_string_literal: true

FactoryBot.define do
  sequence(:description) { |n| "This describes the most impressive nr#{n}" }
  sequence(:email) { |n| "emil@student.chalmers.se" }
  sequence(:firstname) { |n| "Hilbert#{n}" }
  sequence(:lastname) { |n| "Älg#{n}" }
  sequence(:title) { |n| "Titel#{n}" }
end
