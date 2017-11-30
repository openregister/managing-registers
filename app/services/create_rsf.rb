class CreateRsf
  def self.call(payload, register_name)
    payload_sha = Digest::SHA256.hexdigest payload.to_json
    current_date_register_format = DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    record_key = payload[register_name]

    item = "add-item\t#{JSON::dump(payload)}"
    entry = "append-entry\tuser\t#{record_key}\t#{current_date_register_format}\tsha-256:#{payload_sha}"

    "#{item}\n#{entry}"
  end
end
