class BookingsController < ApplicationController
  before_action :set_vehicle, if: -> { params[:vehicle_id].present? }
  before_action :set_booking, only: %i[show edit update destroy]

  def index
    @bookings = @vehicle ? @vehicle.bookings : Booking.all
  end

  def show; end

  def new
    @booking = @vehicle.bookings.build
  end

  def create
    @booking = @vehicle.bookings.build(booking_params)
    @booking.user = current_user

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
end
