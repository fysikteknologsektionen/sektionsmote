# frozen_string_literal: true

class StartPage
  attr_accessor :items, :news, :vote_status

  def initialize
    @items = Item.not_closed.order(Arel.sql("substring(items.position, '\\d+')::int NULLS FIRST, items.position, sub_items.position")) || []
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
    @vote_status = VoteStatusView.new
  end
end
