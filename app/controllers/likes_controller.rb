class LikesController < ApplicationController
  before_action :set_like, only: :destroy
  before_action :ensure_loggin

  def create
    dog_id = params[:dog_id]
    @like = Like.new(dog_id: dog_id)
    @like.user_id = current_user.id

    if @like.save
      redirect_to dog_url(dog_id)
    else
      redirect_to dog_url(dog_id), notice: @like.errors.full_messages.first
    end
  end

  def destroy
    @like.destroy
    redirect_to dog_url(@like.dog_id)
  end

  private

    def set_like
      @like = Like.find(params[:id])
    end

end
