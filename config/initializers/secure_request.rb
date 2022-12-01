WmsResource::SecureRequest.salt = YAML.load_file(Rails.root.join("config", "secreq.yml"))[Rails.env]["salt"]
