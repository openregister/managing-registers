class Policy

  class << self

    # Method that check all the values are not nil
    def values_present?(*args)
      args.all?
    end

  end
end