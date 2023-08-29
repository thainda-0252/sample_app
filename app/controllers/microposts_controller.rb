class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "micropost.create.success"
      redirect_to root_url
    else
      create_failed
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.destroy.success"
    else
      flash[:danger] = "micropost.destroy.failed"
    end
    redirect_to ( request.referer || root_path), status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @micropost.nil?
  end

  def create_failed
    @pagy, @feed_items = pagy current_user.feed, items: Settings.pages.items
    render "static_pages/home", status: :unprocessable_entity
  end
end
