json.extract! parsed_email_record, :id, :inbound_email_id, :email, :type, :data, :sent_at, :created_at, :updated_at
json.url parsed_email_record_url(parsed_email_record, format: :json)
