class Status < ApplicationRecord
  belongs_to :change
  has_one :user
end
