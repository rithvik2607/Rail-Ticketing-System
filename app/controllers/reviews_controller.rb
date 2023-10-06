class ReviewsController < ApplicationController
  helper_method :authorized_user?
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    if @train.nil?
      @train = Train.find(params[:train_id])
    end
  end

  # GET /reviews/1/edit
  def edit
    if @current_user.is_admin || authorized_user?(@review.passenger.id)
    else
      respond_to do |format|
        format.html { redirect_to reviews_path, notice: "Not authorized to edit another user's reviews" }
        format.json { head :no_content }
      end
    end
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    # link review to train and passenger
    @review.train = Train.find(params[:review][:train_id])
    @review.passenger = current_user
    # update rating for train
    @train = Train.find(params[:review][:train_id])
    if Review.where(train_id: params[:review][:train_id])
      reviews = Review.where(train_id: params[:review][:train_id])
      ratingSum = @review.rating + reviews.sum("rating")
      @train.rating = ratingSum / (reviews.size + 1)
    else
      @train.rating = @review.rating
    end
    @train.save

    respond_to do |format|
      if @review.save
        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    # update rating for train
    if @current_user.is_admin || authorized_user?(@review.passenger.id)
      review = Review.find(@review.id)
      @train = Train.find(params[:review][:train_id])
      reviews = Review.where(train_id: @review.train.id)
      ratingSum = @review.rating + reviews.sum("rating") - review.rating
      @train.rating = ratingSum / (reviews.size)
      @train.save

      respond_to do |format|
        if @review.update(review_params)
          format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
          format.json { render :show, status: :ok, location: @review }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to update another user's reviews" }
        format.json { head :no_content }
      end
    end
  end


  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    if @current_user.is_admin || authorized_user?(@review.passenger.id)
      @review.destroy

      respond_to do |format|
        format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to update another user's reviews" }
        format.json { head :no_content }
      end
    end
  end

  def filter_reviews
    @filtered_reviews = []
    
    if params[:name] && params[:train_number]
      @filtered_reviews = Review.joins(:passenger, :train).where(passenger: { name: params[:name] }, train: { train_number: params[:train_number] })
    end  
    if params[:name]=='' && params[:train_number]!=''
      required_train = Train.where(train_number: params[:train_number])
      @filtered_reviews = Review.where(train: required_train)
    end
    if params[:name]!='' && params[:train_number]==''
      required_passenger = Passenger.where(name: params[:name])
      @filtered_reviews = Review.where(passenger: required_passenger)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:rating, :feedback)
    end
end
