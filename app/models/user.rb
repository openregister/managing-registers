class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :countries
  has_many :territories
  has_many :local_authority_engs
  has_many :local_authority_types

  def admin?
    role == "admin"
  end

  def standard?
    role == "standard"
  end

  def guest?
    role == "guest"
  end
end
