class BookingsController < ApplicationController

  before_action :check_from
  before_action :check_sender

  def booking
    render json: { message: 'successful'}, status: 200
  end

  private
    def check_from
      return render json: { error: 'from is empty'}, status: 404 if params[:from].blank?
      return render json: { error: 'from_name is empty'}, status: 404 if params[:from][:name].blank?
      return render json: { error: 'from_lat is empty'}, status: 404 if params[:from][:lat].blank?
      return render json: { error: 'from_lng is empty'}, status: 404 if params[:from][:lng].blank?
    end
    def check_sender
      return render json: { error: 'sender is empty'}, status: 404 if params[:sender].blank?
      return render json: { error: 'sender_name is empty'}, status: 404 if params[:sender][:name].blank?
      return render json: { error: 'sender_cell is empty'}, status: 404 if params[:sender][:cell].blank?
      return render json: { error: 'sender_email is empty'}, status: 404 if params[:sender][:email].blank?
    end

end

=begin
{
  "from":
    { "name" : "Wapda Town", "lat": "123.0", "lng": "1338.808" }
    ,
    "sender":
    { "name":"Noshiad Ali Buttar", "cell":"+921234564", "email":"noshaid.ali@novatoresols.com" },
  "slot_id" :112,
  "orders":
  [
    {
      "to":
      { "name": "Wapda Town", "lat": "123.0", "lng": "1338.808" },

      "recepient":
      { "name": "Muazzam Ali Abbas", "phone": "+923218858069", "email": "muazzam.abbas@novatoresols.com" },

      "quantity":
      { "small": "1", "medium": "2", "large": "0" },

      "invoice":
      [
        { "quantity": 1, "name": "perfum", "price": 150, "image": "" }
      ],
      "amount": 123,
      "total_amount": 123,
      "instructions": "Handle Softly"
    }
  ]
}
=end
