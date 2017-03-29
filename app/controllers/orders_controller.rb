class OrdersController < ApplicationController

  before_action :set_order, only: [:show]

  def show
    @line_items  = @order.line_items.page(params[:page])
    @locations = [ @order.booking.location, @order.location ]
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lon
      marker.infowindow location.name
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
