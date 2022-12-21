WmsResource::SecureRequest.salt = ENV.fetch('SECURE_REQUEST_SALT') { YAML.load_file(Rails.root.join("config", "secreq.yml"))[Rails.env]["salt"] }
