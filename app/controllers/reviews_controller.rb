class ReviewsController < ApplicationController
  before_action :set_vehicle
  before_action :set_booking
  before_action :set_review, only: %i[show edit update destroy]

  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking = @booking
    @review.vehicle = @vehicle

    if @review.save
      redirect_to vehicle_booking_review_path(@vehicle, @booking, @review), notice: "Review created successfully."
    else
      render :new, status: :unprocessable_entity
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
    params.require(:review).permit(:rating, :comment, :user_id, :vehicle_id, :booking_id)
  end
end
