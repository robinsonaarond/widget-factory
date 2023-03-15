VendorApiAccess = if ENV['VENDOR_API_ACCESS'].present?
                    YAML.load(ENV.fetch('VENDOR_API_ACCESS'))
                  else
                    YAML.load_file(Rails.root.join('config', 'vendor_api_data.yml'))
                  end
