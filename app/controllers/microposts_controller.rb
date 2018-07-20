class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def new
    @micropost = current_user.microposts.build
    @microposts = current_user.microposts.page(params[:page])
      .per(Settings.microposts.per_page)
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t("micropost_created")
      redirect_to post_path
    else
      @microposts = current_user.microposts.page(params[:page])
      .per(Settings.microposts.per_page)
      render :new
    end
  end

  def show
    @micropost =  Micropost.find_by id: params[:id]
    @user = @micropost.user
    @comments = @micropost.comments
    @comment_new = Comment.new
  end

  def destroy
    @micropost.destroy
    flash[:success] = t("micropost_deleted")
    redirect_to request.referrer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :picture, :title
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end
end
