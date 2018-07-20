class StaticPagesController < ApplicationController
  def home
    if logged_in? && current_user.following.count != 0
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page])
          .per(Settings.microposts.per_page)
    else
      @feed_items = Micropost.all.page(params[:page])
        .per(Settings.microposts.per_page)
    end
  end

  def help; end

  def contact; end

  def about; end
end
