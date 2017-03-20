class FetchLocalAuthorityEngFromLocalAuthorityEngRegisterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    local_authority_engs.each do |c|
      local_authority_eng = LocalAuthorityEng.find_or_initialize_by(code: c[:code])

      local_authority_eng.name = c[:name]
      local_authority_eng.official_name = c[:official_name]
      local_authority_eng.local_authority_type = c[:local_authority_type]
      local_authority_eng.start_date = c[:start_date]
      local_authority_eng.end_date = c[:end_date]

      if local_authority_eng.changed? || local_authority_eng.new_record?
        local_authority_eng.save!
      end
    end
  end

  private

  def local_authority_engs
    local_authority_eng_records = OpenRegister.register('local-authority-eng', :beta)._all_records
    local_authority_eng_records.map { |r| {
      code: r.local_authority_eng,
      official_name: r.official_name,
      name: r.name,
      local_authority_type: r.local_authority_type,
      start_date: r.start_date,
      end_date: r.end_date }
    }
  end
end
