class CommentsController < ApplicationController
  before_action :redirect_if_user_is_not_signed_in

  def create
    @current = current_user.comments.create(comment_params)
    flash[:notice] = "Your comment has been added"
    redirect_to posts_url
  end

  def edit
    @comment = Comment.find(params[:id])
    if @comment.update_valid?
      @comment
    else
      redirect_to posts_url
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id 
      @comment.update(comment_params)
      flash[:notice] = "Your comment has been updated"
    else
      flash[:error] = "You cannot update other people's comments"
    end
    redirect_to posts_url
  end

  def destroy 
    @comment = Comment.find(params[:id])
      if @comment.user_id == current_user.id
        @comment.destroy
        flash[:notice] = "Your comment has been deleted"
      else
        flash[:error] = "You cannot delete other people's posts"
      end
    redirect_to posts_url
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :post_id)
  end
end
