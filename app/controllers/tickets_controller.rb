class TicketsController < ApplicationController
  helper_method :authorized_user?
  before_action :set_ticket, only: %i[ show edit update destroy ]
  before_action :authorized

  # GET /tickets or /tickets.json
  def index
    if @current_user.is_admin
      @tickets = Ticket.all
    else
      respond_to do |format|
        format.html { redirect_to '/' }
        format.json { head :no_content }
      end
    end
  end

  # GET /tickets/1 or /tickets/1.json
  def show
    if @current_user.is_admin || authorized_user?(@ticket.passenger.id)
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Not authorized to view another user's tickets" }
        format.json { head :no_content }
      end
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    if @train.nil?
      @train = Train.find(params[:train_id])
    end
    @credit_card = current_user.credit_card_information
  end

  # GET /tickets/1/edit
  # def edit
  # end
  

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    
    # create a random confirmation number using a random string of length 10
    @ticket.confirmation_number = Array.new(10){[*"A".."Z", *"0".."9"].sample}.join
    # link ticket to train and passenger
    @ticket.train = Train.find(params[:ticket][:train_id])
    @ticket.passenger = current_user
    # update number of tickets available in train
    @train = Train.find(params[:ticket][:train_id])
    @train.number_of_seats_left = @train.number_of_seats_left - 1
    @train.save

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to ticket_url(@ticket), notice: "Ticket was successfully created." }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to ticket_url(@ticket), notice: "Ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # def passengerTickets
  #   tickets = Ticket.all
  #   trips = tickets.select { |ticket| ticket.passenger_id == current_user.id }
  # end

  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @train = Train.find(@ticket.train_id)
    @train.number_of_seats_left = @train.number_of_seats_left + 1
    @train.save
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url, notice: "Ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:train_id)
    end
end
