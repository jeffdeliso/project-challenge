class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update]

  # GET /dogs
  # GET /dogs.json
  def index
    if params[:sort] == 'likes'
      @dogs = Dog.paginate(:page => params[:page], :per_page => 5).joins("LEFT OUTER JOIN likes ON likes.dog_id = dogs.id 
                   AND likes.created_at >= datetime('now', '-1 Hour')").group(:id).order('COUNT(likes.id) DESC')
    else
      @dogs = Dog.paginate(:page => params[:page], :per_page => 5).order(created_at: :asc)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @like = Like.find_by(dog_id: @dog.id, user_id: current_user.id) if current_user
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.owner_id = current_user.id

    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, images: [])
    end

    def ensure_owner
      redirect_to @dog if current_user.id != @dog.owner_id
    end
end
