class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: { message: "Name is required" }, length: {in: 3..150}, numericality: false
  validates :email, presence: { message: "Email is required"}, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true,  length: {in: 6..30},  confirmation: true
  validates :cell, presence: true, length: {in: 7..14}, uniqueness: true
  validates :verified, inclusion: {in: [true, false]}
  validates :verified_token, uniqueness: true
  validates :role, presence: true, acceptance: {accept: ["consumer", "driver", "admin"]}

end
