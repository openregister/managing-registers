class FetchTerritoriesFromTerritoryRegisterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    territories.each do |c|
      territory = Territory.find_or_initialize_by(code: c[:code])

      territory.name = c[:name]
      territory.official_name = c[:official_names]
      territory.start_date = c[:start_date]
      territory.end_date = c[:end_date]

      if territory.changed? || territory.new_record?
        territory.save!
      end
    end
  end

  private

  def territories
    territory_records = OpenRegister.register('territory', :beta)._all_records
    territory_records.map { |r| {
      code: r.territory,
      official_names: r.official_name,
      name: r.name,
      start_date: r.start_date,
      end_date: r.end_date }
    }
  end
end
