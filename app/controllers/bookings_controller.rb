class BookingsController < ApplicationController
  before_action :set_vehicle, if: -> { params[:vehicle_id].present? }
  before_action :set_booking, only: %i[show edit update destroy cancel accept reject]

  def index
    # @bookings = @vehicle ? @vehicle.bookings : Booking.all
    if params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      # For renter: Show bookings only for THIS specific vehicle
      if current_user.renter?
        @bookings = Booking.joins(:vehicle)
                          .where(vehicle_id: @vehicle.id)
                          .where(vehicles: { user_id: current_user.id })
      else
        # For regular user: Still show ALL their bookings (ignore vehicle filter)
        @bookings = current_user.bookings
      end
    else
      if current_user.renter?
        # Bookings for vehicles owned by the current renter
        @bookings = Booking.joins(:vehicle).where(vehicles: { user_id: current_user.id })
      else
        # Bookings made by the user
        @bookings = current_user.bookings
      end
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @message = Message.new
    @messages = @booking.messages
  end

  def new
    @booking = @vehicle.bookings.build
  end

  def create
    @booking = @vehicle.bookings.build(booking_params)
    @booking.user = current_user
    @booking.status = "pending"
    @booking.payment_status = "unpaid"

    if @booking.save
      redirect_to [@vehicle, @booking], notice: 'Booking was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @booking.update(booking_params)
      redirect_to [@vehicle, @booking], notice: 'Booking was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    # Redirect depending on whether it's nested or global
    if @vehicle
      redirect_to vehicle_bookings_path(@vehicle), notice: 'Booking was successfully destroyed.'
    else
      redirect_to bookings_path, notice: 'Booking was successfully destroyed.'
    end
  end

  # User cancels booking
  def cancel
    authorize_user_for_cancellation!
    if @booking.pending? || @booking.accepted?
      if @booking.update(status: :cancelled)
        redirect_to bookings_path, notice: "Booking cancelled."
      else
        redirect_to vehicle_booking_path(@booking.vehicle, @booking), alert: "Could not cancel booking."
      end
    end
  end

  # Renter accepts booking
  def accept
    authorize_renter_for_booking!
    if @booking.pending?
      @booking.accepted!
      redirect_to vehicle_booking_path(@booking.vehicle, @booking), notice: "Booking accepted."
    else
      redirect_to vehicle_booking_path(@booking.vehicle, @booking), alert: "Booking cannot be accepted."
    end
  end

  # Renter rejects booking
  def reject
    authorize_renter_for_booking!
    if @booking.pending?
      @booking.rejected!
      redirect_to vehicle_booking_path(@booking.vehicle, @booking), notice: "Booking rejected."
    else
      redirect_to vehicle_booking_path(@booking.vehicle, @booking), alert: "Booking cannot be rejected."
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:vehicle_id]) if params[:vehicle_id]
  end

  def set_booking
    @booking = @vehicle ? @vehicle.bookings.find(params[:id]) : Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :pickup_address, :dropoff_address, :total_price, :status, :payment_status)
  end

  def authorize_user_for_cancellation!
    return if current_user == @booking.user
    redirect_to root_path, alert: "You are not authorized to cancel this booking."
  end

  def authorize_renter_for_booking!
    return if current_user == @booking.vehicle.user
    redirect_to root_path, alert: "You are not authorized to manage this booking."
  end
end
