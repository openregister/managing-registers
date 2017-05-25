class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  has_many :teams, through: :team_members

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

  def get_team_id

  end

end
