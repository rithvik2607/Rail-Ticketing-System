class TrainsController < ApplicationController
  helper_method :authorized_user?
  before_action :set_train, only: %i[ show edit update destroy ]

  # GET /trains or /trains.json
  def index
    if @current_user.is_admin
      @trains = Train.all
    else
      respond_to do |format|
        format.html { redirect_to '/' }
        format.json { head :no_content }
      end
    end
    
  end

  # GET /trains/1 or /trains/1.json
  def show
    if @current_user.is_admin
    
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to view all trains." }
        format.json { head :no_content }
      end
    end
  end

  # GET /trains/new
  def new
    if @current_user.is_admin
      @train = Train.new
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to create new train" }
        format.json { head :no_content }
      end
    end
    
  end

  # GET /trains/1/edit
  def edit
    if @current_user.is_admin
    else
      respond_to do |format|
        format.html { redirect_to viewTrains_path, notice: "Not authorized to edit trains" }
        format.json { head :no_content }
      end
    end
  end

  # POST /trains or /trains.json
  def create
    @train = Train.new(train_params)
    if Train.find_by(train_number: @train.train_number)
      @train.rating = Train.find_by(train_number: @train.train_number).rating
    end

    respond_to do |format|
      if @train.save
        format.html { redirect_to train_url(@train), notice: "Train was successfully created." }
        format.json { render :show, status: :created, location: @train }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @train.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trains/1 or /trains/1.json
  def update
    respond_to do |format|
      if @train.update(train_params)
        format.html { redirect_to train_url(@train), notice: "Train was successfully updated." }
        format.json { render :show, status: :ok, location: @train }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @train.errors, status: :unprocessable_entity }
      end
    end
  end

  def passengerTrains
    res = []
    trains = Train.all
    
    for i in 0 ... trains.length
      combined_datetime = DateTime.new(trains[i].departure_date.year, trains[i].departure_date.month, trains[i].departure_date.day, trains[i].departure_time.hour, trains[i].departure_time.min, trains[i].departure_time.sec)
      if combined_datetime > Time.now and trains[i].number_of_seats_left > 0
        res.append(trains[i])
      end
    end
    res
  end

  # DELETE /trains/1 or /trains/1.json
  def destroy
    if current_user.is_admin
      @train.destroy
    
      respond_to do |format|
        format.html { redirect_to trains_url, notice: "Train was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to delete trains." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_train
      @train = Train.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def train_params
      params.require(:train).permit(:train_number, :departure_station, :termination_station, :departure_date, :departure_time, :arrival_date, :arrival_time, :ticket_price, :train_capacity, :number_of_seats_left)
    end
end
