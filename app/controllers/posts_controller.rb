class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show] # make sure user is logged in
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|post| post.total_votes}.reverse

    respond_to do |format|
      format.html
      format.xml {render :xml => @posts}
      format.js {render :json => @posts.to_json}
    end
  end

  def show
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.xml {render :xml => @post}
      format.js {render :json => @post.to_json}
    end

  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash["notice"] = "Your post was created."
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash["notice"] = "Your post was updated."
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.html do 
        if @vote.valid?
          flash['notice'] = "Your vote was casted."
        else
          flash['error'] = "You can only vote on a post once."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def require_creator
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
  end

end
