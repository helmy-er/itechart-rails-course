# frozen_string_literal: true

class User < ApplicationRecord
  has_many :people
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, length: { maximum: 20 }
end
