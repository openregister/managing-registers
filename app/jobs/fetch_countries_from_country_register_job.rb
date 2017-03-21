class FetchCountriesFromCountryRegisterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    countries.each do |c|
      country = Country.find_or_initialize_by(code: c[:code])
      user = User.find_by(email: "tony.worron@fco.gsi.gov.uk")

      country.name = c[:name]
      country.official_name = c[:official_names]
      country.citizen_name = c[:citizen_name]
      country.start_date = c[:start_date]
      country.end_date = c[:end_date]
      country.user_id = user.id

      if country.changed? || country.new_record?
        country.save!
      end
    end
  end

  private

  def countries
    country_records = OpenRegister.register('country', :beta)._all_records
    country_records.map { |r| {
      code: r.country,
      official_names: r.official_name,
      name: r.name,
      citizen_name: r.citizen_names,
      start_date: r.start_date,
      end_date: r.end_date }
    }
  end
end
