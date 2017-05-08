class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true

  def admin?
    role == "admin"
  end

  def custodian?
    role == "custodian"
  end

  def advanced?
    role == "advanced"
  end

  def basic?
    role == "basic"
  end
end
