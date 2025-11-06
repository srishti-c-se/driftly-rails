class HomeController < ApplicationController
  def index
    @featured_vehicles = Vehicle.limit(4)
  end
end
