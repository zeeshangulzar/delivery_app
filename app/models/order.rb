class Order < ActiveRecord::Base

  belongs_to :booking
  belongs_to :driver, foreign_key: 'driver_id', class_name: 'User'
  belongs_to :recipient, foreign_key: 'recipient_id', class_name: 'User'

  has_one :location, as: :locateable
  has_many :line_items

  validates_presence_of :booking
  validates :recipient_name, :recipient_cell, :recipient_email, presence: true, if: 'recipient_id.blank?'
  validates :amount, :charges, presence: true
  validate :validate_recipient_id, if: 'recipient_id.present?'

  before_create :create_tracking_id

  private

  def create_tracking_id
    begin
      self. tracking_id = [*('a'..'z'),*('A'..'Z'),*('0'..'9')].shuffle[0,8].join
    end while self.class.exists?(:tracking_id => tracking_id)
  end

  def self.save_order(params)
    order = self.new
    if params[:recipient].present?
      if params[:recipient][:id].present?
        order.recipient_id = params[:recipient][:id]
      else
        order.recipient_name = params[:recipient][:name]
        order.recipient_cell = params[:recipient][:cell]
        order.recipient_email = params[:recipient][:email]
      end
    end
    order.amount = params[:amount]
    if params[:quantity].present?
      order.small = params[:quantity][:small]
      order.medium = params[:quantity][:medium]
      order.large = params[:quantity][:large]
    end
    order.charges = params[:charges]
    order.instruction = params[:instructions]
    order.save
    order
  end

  def validate_recipient_id
    errors.add(:recipient_id, "id is invalid") unless User.exists?(self.recipient_id)
  end


end
