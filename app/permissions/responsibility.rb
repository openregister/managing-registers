class Responsibility
  class << self
    def manager?(user)
      user.custodian? || user.advanced?
    end

    def user?(user)
      user.custodian? || user.advanced? || user.basic?
    end
  end
end
