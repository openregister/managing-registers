class Territory < ApplicationRecord
  include MultiStepModel

  belongs_to :user

  validates :user_id, presence: true

  def self.total_steps
    2
  end
end
