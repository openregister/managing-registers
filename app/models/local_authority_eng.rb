class LocalAuthorityEng < ApplicationRecord
  include MultiStepModel

  def self.total_steps
    2
  end
end
