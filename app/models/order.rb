class Order < ActiveRecord::Base

  belongs_to :booking
  belongs_to :driver, foreign_key: 'driver_id', class_name: 'User'
  belongs_to :recipient, foreign_key: 'recipient_id', class_name: 'User'

  has_one :location, as: :locateable
  has_many :line_items

  validates_presence_of :booking

  before_create :create_tracking_id

  private

  def create_tracking_id
    begin
      self. tracking_id = [*('a'..'z'),*('A'..'Z'),*('0'..'9')].shuffle[0,8].join
    end while self.class.exists?(:tracking_id => tracking_id)
  end

end
