class CommentsController < ApplicationController
  before_action :require_user

  def create
    @comment = Comment.new(comment_params)
    @comment.creator = current_user
    @comment.post = @post

    if @comment.save
      flash["notice"] = "Your comment was created."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: comment)

    if vote.valid?
      flash['notice'] = "Your vote was casted."
    else
      flash['error'] = "You can only vote on a comment once."
    end

    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
