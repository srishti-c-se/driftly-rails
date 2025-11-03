class MessagesController < ApplicationController
  def create
    @booking = Booking.find(params[:booking_id])
    @message = @booking.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to booking_path(@booking) }
      end
    else
      @messages = @booking.messages
      render "bookings/show", status: :unprocessable_entity
    end
  end

  def update

  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
