class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  has_many :teams, through: :team_members
  accepts_nested_attributes_for :teams

  validates :full_name, presence: true
  validates :password, length: { minimum: 8 }

  accepts_nested_attributes_for :team_members

  def role
    team_members.first.role
  end

  def admin?
    team_members.first.role == 'admin'
  end

  def custodian?
    team_members.first.role == 'custodian'
  end

  def advanced?
    team_members.first.role == 'advanced'
  end

  def basic?
    team_members.first.role == 'basic'
  end

end
