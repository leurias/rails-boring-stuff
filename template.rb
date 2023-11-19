def source_paths
  Array(super) + [File.expand_path(File.dirname(__FILE__))]
end

def list_files
  base_path = File.join(__dir__, "stubs")
  files_output = `find #{base_path} -type f -printf "%P\n"`
  files_array = files_output.split("\n")
  files_array
end

def copy_and_replace(source, dest = nil)
  dest_file = dest.nil? ? source : dest
  copy_file("stubs/#{source}", dest_file, force: true)
end

gem_group :development, :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'dotenv-rails'
end

gem 'alba'
gem 'devise'
gem 'devise-jwt'
gem 'oj'
gem 'rack-cors'
gem "redis", ">= 4.0.1"
gem 'sidekiq', '~> 7.0.3'

## --------------------------------------------------
## Installers
## --------------------------------------------------

run 'bundle install'

## --------------------------------------------------
## Copy Stubs
## --------------------------------------------------

list_files.each do |file_path|
  copy_and_replace file_path
end
