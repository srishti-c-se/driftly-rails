class ReviewsController < ApplicationController
  before_action :set_vehicle
  before_action :set_review, only: %i[show edit update destroy]

  def index
    @reviews = Review.all
  end

  def new
    if @booking.user == current_user
      @review = Review.new
    else
      redirect_to @vehicle, alert: "You can only review vehicles you have booked."
    end
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking = @booking
    @review.vehicle = @vehicle

    if @booking.user == current_user
      if @review.save
        redirect_to @vehicle, notice: "Review created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to @vehicle, alert: "You can only review vehicles you have booked."
    end
  end

  # DELETE /vehicles/:vehicle_id/bookings/:booking_id/reviews/:id
  # Only the review author or the renter/vehicle owner can delete.
  def destroy
    if current_user == @review.user || current_user.renter?
      @review.destroy
      redirect_to vehicle_path(@vehicle), notice: "Review deleted successfully."
    else
      redirect_to vehicle_path(@vehicle), alert: "You are not authorized to delete this review."
    end
  end

  def edit
    # Only the user who created the review can edit
    redirect_to @vehicle, alert: "Not authorized" unless current_user == @review.user
  end

  def update
    if current_user == @review.user
      if @review.update(review_params)
        redirect_to vehicle_path(@vehicle), notice: "Review updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @vehicle, alert: "Not authorized"
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:vehicle_id])
  end

  def set_booking
    @booking = @vehicle.bookings.find(params[:booking_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
