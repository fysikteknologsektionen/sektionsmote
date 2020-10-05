# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def about; end

  def cookies_information; end

  def index
    @start_page = StartPage.new
    @start_page.vote_status.vote_post = VotePost.where(vote: @start_page.vote_status.vote, user: current_user).first
  end

  def terms; end
end
