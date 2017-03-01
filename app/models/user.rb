class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :social_logins

  # For api authentication
  has_many :authentication_tokens

  validates :name, presence: { message: "Name is required" }, length: {in: 3..150}, numericality: false
  validates :email, presence: { message: "Email is required"}
  validates :password, presence: true,  confirmation: true
  validates :cell, presence: true, length: {in: 7..14}, uniqueness: true
  validates :verified, inclusion: {in: [true, false]}
  #validates :verified_token, uniqueness: true
  validates :role, presence: true, inclusion: { in: ["consumer", "driver", "admin"] }

end
