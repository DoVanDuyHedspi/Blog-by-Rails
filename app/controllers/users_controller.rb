class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
    :following, :followers]
  before_action :admin_user, only: [:destroy]
  before_action :load_user, only: [:show, :edit, :update, :destroy, :following,
    :followers]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.select_user_activated.page(params[:page])
      .per(Settings.users.per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t("please_check_email")
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.page(params[:page])
      .per(Settings.microposts.per_page)
    @micropost = current_user.microposts.build
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:error] = t("cannot_delete")
    end
    redirect_to users_url
  end

  def following
    @title = t("following")
    @users = @user.following.page(params[:page]).per(Settings.users.per_page)
    render "show_follow"
  end

  def followers
    @title = t("followers")
    @users = @user.followers.page(params[:page]).per(Settings.users.per_page)
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless @user&.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]

    return @user if @user
    flash[:warning] = t("no_user_warning")
    redirect_to root_path
  end
end
