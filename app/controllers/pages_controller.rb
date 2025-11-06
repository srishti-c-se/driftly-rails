class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @featured_vehicles = Vehicle.limit(4)
  end
end
