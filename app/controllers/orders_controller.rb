class OrdersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
  before_action :set_order, only: [:show]
  before_action :token_authentication, only: [:track_order]
  before_action :check_params_presense, only: [:track_order]
  before_action :set_order_by_tracking_id, only: [:track_order]


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

  def track_order
  end


  private

    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_by_tracking_id
      @order = Order.find_by_tracking_id(params[:tracking_id])
      return render json: { error: 'Order not found'}, status: 404 if @order.blank?
    end

    def check_params_presense
      return render json: { error: "tracking id can't be nil"}, status: 404 if params[:tracking_id].blank?
    end


end
