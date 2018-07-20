class CommentsController < ApplicationController
  before_action :load_comment, only: [:update, :destroy]

  def create
    @comment = current_user.comments.create comment_params
    unless @comment
      flash[:error] = t("can_not_comment")
    end
    @micropost = @comment.micropost
    respond_to do |format|
      format.html{redirect_to request.referrer}
      format.js
    end
  end

  def edit
    @comment_edit = Comment.find params[:id]
    @micropost = @comment_edit.micropost
    respond_to do |format|
      format.html{redirect_to request.referrer}
      format.js
    end
  end

  def update
    @id = @comment.id
    # @comment.update_attributes comment_params
    unless @comment.update_attributes comment_params
      flash[:error] = t("can_not_update_comment")
    end
    @cmt_updated = Comment.find @id
    respond_to do |format|
      format.html{redirect_to request.referrer}
      format.js
    end
  end

  def destroy
    @comment_deleted = @comment.destroy

    respond_to do |format|
      format.html{redirect_to request.referrer}
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content, :micropost_id
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    redirect_to root_url if @comment.nil?
  end
end
