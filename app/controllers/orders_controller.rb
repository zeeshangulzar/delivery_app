class OrdersController < ApplicationController

  before_action :set_order, only: [:show]

  def show
    @line_items  = @order.line_items.page(params[:page])
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
