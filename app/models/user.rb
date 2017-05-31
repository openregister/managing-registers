class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  has_many :teams, through: :team_members

  validates :full_name, presence: true

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

  # this is a stop gap until we understand how users who are both advanced and
  # custodian will view teams. For now we just add them to the most
  # If custodian return team you are custodian for
  # If advanced user and not custodian then return that team id
  def get_team_id_with_highest_permissions
    custodians = team_members.where(role: 'custodian')
    advanced = team_members.where(role: 'advanced')

    if custodians.records.length > 0
      return custodians.records.first.team_id
    elsif advanced.records.length > 0
      return advanced.records.first.team_id
    end

  end

end
