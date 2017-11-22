# frozen_string_literal: true

class Policy
  class << self
    # Method that check all the values are not nil
    def values_present?(*args)
      args.all?
    end

    def log(message)
      Rails.logger.warn "[PERMISSION ERROR] #{message}"
    end
  end
end
