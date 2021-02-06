# frozen_string_literal: true

class VotePostsController < ApplicationController
  authorize_resource

  def show
    @vote = Vote.find(params[:vote_id])
    if !@vote.open?
      redirect_to(votes_path, alert: t('.is_closed'))
    else
      @vote_post = VotePost.new
    end
  end

  def create
    @vote = Vote.find(params[:vote_id])
    @vote_post = @vote.vote_posts.build(vote_post_params)
    @vote_post.user = current_user

    return_to = Rails.application.routes.recognize_path('/')
    return_to = @vote.sub_item.item if return_to.nil?

    if VoteService.user_vote(@vote_post)
      redirect_to(return_to, notice: t('.success'))
    else
      render(:error, status: 422)
    end
  end

  private

  def vote_post_params
    if params.has_key?(:vote_post)
      params.require(:vote_post).permit(:id, :votecode, vote_option_ids: [])
    else
      {}
    end
  end
end
