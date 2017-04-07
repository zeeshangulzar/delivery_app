class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :social_logins
  has_many :bookings
  has_many :orders

  has_many :locations, as: :locateable
  has_many :authentication_tokens
  has_one :profile

  validates :name, presence: { message: "is required" }, length: {in: 3..150}, numericality: false
  #validates :email, presence: { message: "is required"}
  validates :cell, presence: true, length: {in: 7..14}, uniqueness: true
  validates :verified, inclusion: {in: [true, false]}
  #validates :verified_token, uniqueness: true
  validates :role, presence: true, inclusion: { in: ["consumer", "driver", "admin"] }

  paginates_per 10

  ROLES = ["consumer", "driver", "admin"]

  def send_sms
    client = Twilio::REST::Client.new(APP_CONFIG[:twillio][:sid], APP_CONFIG[:twillio][:auth])
    client.messages.create to: cell,
    from: APP_CONFIG[:twillio][:number],
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

  def self.get_list(params)
    users = self.where(status: params[:status])
    users = users.where(role: params[:role])
    users = users.where("name LIKE (?)", "%#{params[:name].strip}%") if params[:name].present?
    users = users.where("cell LIKE (?)", "%#{params[:cell].strip}%") if params[:cell].present?
    users = users.where("email LIKE (?)", "%#{params[:email].strip}%") if params[:email].present?
    users = users.where(verified: true) if params[:verified].present?
    users.page(params[:page])
  end

  def user_login_type
   login = self.social_logins.last
   login.blank? ? 'local' : login.platform_name
  end

  def generate_authenticate_token(request)
    Tiddle.create_and_return_token(self, request)
  end

  def email_required?
    false
  end

  def update_status
    status = self.status == 'active' ? 'blocked' : 'active'
    self.update(status: status)
    self
  end

  def self.save_driver(params)
    user = self.new(role: 'driver')
    user.save_user(params)
    # return [user, nil] if user.errors.present?
    profile = user.save_profile(params)
    image = Image::save_image(params[:user][:attachment], profile)
    return [user, profile]
  end

  def save_user(params)
    self.name     = params[:user][:name]
    self.email    = params[:user][:email]
    self.cell     = params[:user][:cell]
    self.password = params[:user][:password]
    self.save
    self
  end

  def save_profile(params)
    p self
    profle                 = self.build_profile
    profile.nationality    = params[:nationality]
    profile.address        = params[:address]
    profile.vehicle_make   = params[:make]
    profile.vehicle_model  = params[:model]
    profile.vehicle_type   = params[:type]
    profile.license_number = params[:license_number]
    profile.plate_name     = params[:plate_name]
    profile.save
    profile
  end

  def is_consumer?
    role == 'consumer'
  end

end
