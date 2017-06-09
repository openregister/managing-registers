class Change < ApplicationRecord
  belongs_to :user
  has_many :statuses
  accepts_nested_attributes_for :statuses
end