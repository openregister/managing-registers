class Register < ApplicationRecord
  belongs_to :team, optional: true
end
