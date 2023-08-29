class FollowingsController < ApplicationController
  before_action :logged_in_user, :find_user

  def index
    @title = t "relationships.followed"
    @pagy, @users = pagy @user.following, items: Settings.pages.items
    render "users/show_follow"
  end
end
