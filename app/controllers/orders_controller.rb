class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_order, only: [:show]

def index
@orders = Order.search(params[:search]).page(params[:page]).per(10)
end

  def show
    @line_items  = @order.line_items.page(params[:page])
    @locations = [ @order.booking.location, @order.location ]
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lon
      marker.infowindow location.name
      marker.picture({
         :url => ActionController::Base.helpers.asset_path('green_marker.png'),
         :width   => 32,
         :height  => 32
      })
    end
    @hash.first[:picture][:url] = ActionController::Base.helpers.asset_path('blue_marker.png')
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
