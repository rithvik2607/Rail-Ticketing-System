class PassengersController < ApplicationController
  helper_method :authorized_user?
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_passenger, only: %i[ show edit update destroy ]
  # before_action :authorized!, except: [:index]

  # GET /passengers or /passengers.json
  def index
    if @current_user.is_admin
      @passengers = Passenger.all
    else
      respond_to do |format|
        format.html { redirect_to '/' }
        format.json { head :no_content }
      end
    end
    # @passengers = Passenger.all
  end

  # GET /passengers/1 or /passengers/1.json
  def show
    if @current_user.is_admin
    
    elsif !authorized_user?(params[:id])
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to view another user" }
        format.json { head :no_content }
      end
    end
  end

  # GET /passengers/new
  def new
    @passenger = Passenger.new
  end

  # GET /passengers/1/edit
  def edit
    if @current_user.is_admin
    elsif !authorized_user?(params[:id])
      respond_to do |format|
        format.html { redirect_to @passenger, notice: "Not authorized to edit another user" }
        format.json { head :no_content }
      end
    end
  end

  # POST /passengers or /passengers.json
  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.is_admin = false
    respond_to do |format|
      if @passenger.save
        format.html { redirect_to passenger_url(@passenger), notice: "Passenger was successfully created." }
        format.json { render :show, status: :created, location: @passenger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @passenger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /passengers/1 or /passengers/1.json
  def update
    respond_to do |format|
      if @passenger.update(passenger_params)
        format.html { redirect_to passenger_url(@passenger), notice: "Passenger was successfully updated." }
        format.json { render :show, status: :ok, location: @passenger }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @passenger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passengers/1 or /passengers/1.json
  def destroy
    if @passenger.is_admin
      respond_to do |format|
        format.html { redirect_to @passenger, notice: "Admin cannnot be deleted" }
        format.json { head :no_content }
      end
    elsif @current_user.is_admin
      @passenger.destroy
      respond_to do |format|
        format.html { redirect_to '/', notice: "Passenger was successfully destroyed by admin." }
        format.json { head :no_content }
      end

    else
      session[:user_id] = nil
      @passenger.destroy
      
      respond_to do |format|
        format.html { redirect_to logout_path, notice: "Passenger was successfully destroyed." }
        format.json { head :no_content }
      end
    end
    
  end

  def viewTrains
    trainController = TrainsController.new
    @res = trainController.passengerTrains
  end
  
  def viewTrips
    tickets = Ticket.all
    reviews = Review.all
    @trips = tickets.select { |ticket| ticket.passenger_id == current_user.id }
    @reviews = reviews.select { |review| review.passenger_id == current_user.id}
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_passenger
      if !Passenger.exists?(params[:id])
        @passenger = Passenger.find(@current_user.id)
      else
        @passenger = Passenger.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def passenger_params
      params.require(:passenger).permit(:name, :email, :password, :password_confirmation, :phone_number, :address, :credit_card_information)
    end
end
