class PassengersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_passenger, only: %i[ show edit update destroy ]

  # GET /passengers or /passengers.json
  def index
    @passengers = Passenger.all
  end

  # GET /passengers/1 or /passengers/1.json
  def show
  end

  # GET /passengers/new
  def new
    @passenger = Passenger.new
  end

  # GET /passengers/1/edit
  def edit
  end

  # POST /passengers or /passengers.json
  def create
    @passenger = Passenger.new(passenger_params)

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
    session[:user_id] = nil
    @passenger.destroy
    
    respond_to do |format|
      format.html { redirect_to logout_path, notice: "Passenger was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def viewTrains
    time = Time.now
    trainController = TrainsController.new
    trains = trainController.index
    @res = []
    for i in 1 ... trains.length
      combined_datetime = DateTime.new(trains[i].departure_date.year, trains[i].departure_date.month, trains[i].departure_date.day, trains[i].departure_time.hour, trains[i].departure_time.min, trains[i].departure_time.sec)
      if combined_datetime > time and trains[i].number_of_seats_left > 0
        @res.append(trains[i])
      end
    end
    @res
  end

  def viewTrips
    ticketController = TicketsController.new
    reviewController = ReviewsController.new
    tickets = ticketController.index
    reviews = reviewController.index
    @trips = tickets.select { |ticket| ticket.passenger_id == current_user.id }
    @reviews = reviews.select { |review| review.passenger_id == current_user.id}
    @reviews.collect { |review| puts review.train_id }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_passenger
      @passenger = Passenger.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def passenger_params
      params.require(:passenger).permit(:name, :email, :password, :password_confirmation, :phone_number, :address, :credit_card_information)
    end
end
