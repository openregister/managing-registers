class CreateRsf
  attr_reader :payload, :register_name

  def initialize(payload, register_name)
    @payload = payload
    @register_name = register_name
  end

  def call
    payload_sha = Digest::SHA256.hexdigest payload.to_json
    current_date_register_format = DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    record_key = payload[register_name]

    item = "add-item\t#{payload.to_json}"
    entry = "append-entry\tuser\t#{record_key}\t#{current_date_register_format}\tsha-256:#{payload_sha}"

    "#{item}\n#{entry}"
  end
end
