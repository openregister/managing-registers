class FetchLocalAuthorityTypeFromLocalAuthorityTypeRegisterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    local_authority_types.each do |c|
      local_authority_type = LocalAuthorityType.find_or_initialize_by(code: c[:code])
      user = User.find_by(email: "stephen.mcallister@communities.gsi.gov.uk")

      local_authority_type.name = c[:name]
      local_authority_type.start_date = c[:start_date]
      local_authority_type.end_date = c[:end_date]
      local_authority_type.user_id = user.id

      if local_authority_type.changed? || local_authority_type.new_record?
        local_authority_type.save!
      end
    end
  end

  private

  def local_authority_types
    local_authority_type_records = OpenRegister.register('local-authority-type', :beta)._all_records
    local_authority_type_records.map { |r| {
      code: r.local_authority_type,
      name: r.name,
      start_date: r.start_date,
      end_date: r.end_date }
    }
  end
end
