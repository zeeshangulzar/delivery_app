class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :social_logins
  has_many :bookings
  has_many :orders

  has_many :locations, as: :locateable

  # For api authentication
  has_many :authentication_tokens

  TWILLIO_SID    = 'AC969f17cb864ec269d068d4e4ff32c397'
  TWILLIO_AUTH   = 'f9ca79e8e38852c26e106876338bda2b'
  TWILLIO_NUMBER = '+14692086400'

  validates :name, presence: { message: "is required" }, length: {in: 3..150}, numericality: false
  validates :email, presence: { message: "is required"}
  validates :cell, presence: true, length: {in: 7..14}, uniqueness: true
  validates :verified, inclusion: {in: [true, false]}
  #validates :verified_token, uniqueness: true
  validates :role, presence: true, inclusion: { in: ["consumer", "driver", "admin"] }

  def send_sms
    client = Twilio::REST::Client.new(TWILLIO_SID, TWILLIO_AUTH)
    client.messages.create to: cell,
    from: TWILLIO_NUMBER,
    body: "ANA PIN: #{verified_token}"
  end

  def verification_json(request)
    {
      status: 'true',
      user: {
        id: id,
        name: name,
        email: email,
        cell: cell,
        type: user_login_type,
      },
      token: generate_authenticate_token(request)
    }
  end

  def user_login_type
   login = self.social_logins.last
   login.blank? ? 'local' : login.platform_name
  end

  def generate_authenticate_token(request)
    Tiddle.create_and_return_token(self, request)
  end

end
