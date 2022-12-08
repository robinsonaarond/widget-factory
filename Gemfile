source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"
gem "rails", "~> 7.0.4"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
# gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "dalli", "~> 3.2.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "view_component"
gem "rest-client"
gem "actionpack-page_caching"
gem "actionpack-action_caching"

source "https://gems.moxiworks.com" do
  gem "wms_resource",
    git: "git@github.com:moxiworks/wms_resource.git",
    tag: "4.1.5"
  gem "wms_svc_consumer", "~> 1.0.17"
end

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "web-console"
  gem "lefthook"
  gem "pry"
  gem "standard", require: false
  gem "erb_lint", require: false
  gem "rubocop-rails", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
