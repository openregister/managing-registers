class Change < ApplicationRecord
  belongs_to :user
  has_one :status
end
