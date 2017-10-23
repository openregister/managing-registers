class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  has_many :teams, through: :team_members
  accepts_nested_attributes_for :teams
  accepts_nested_attributes_for :team_members

  validates :full_name, presence: true
  validates :password, length: { minimum: 8 }

  def role
    team_members.first.try(:role)
  end

  def custodian?
    team_members.first.try(:role) == 'custodian'
  end

  def advanced?
    team_members.first.try(:role) == 'advanced'
  end

  def basic?
    team_members.first.try(:role) == 'basic'
  end

  def send_devise_notification(notification, *args)
    unless(notification == :password_change && sign_in_count.zero?)
      super
    end
  end
end
