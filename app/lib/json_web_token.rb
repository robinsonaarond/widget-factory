class JsonWebToken
  SECRET_KEY = ENV.fetch("SECURE_REQUEST_SALT") { YAML.load_file(Rails.root.join("config", "secreq.yml"))[Rails.env]["salt"] }

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
