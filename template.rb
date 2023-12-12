# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-boring-stuff-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/leurias/rails-boring-stuff.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-boring-stuff/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def list_files
  base_path = File.join(source_paths.first, "stubs")
  files_output = `find #{base_path} -type f -printf "%P\n"`
  files_array = files_output.split("\n")
  files_array
end

def copy_and_replace(source, dest = nil)
  dest_file = dest.nil? ? source : dest
  copy_file("#{source_paths.first}/stubs/#{source}", dest_file, force: true)
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

add_template_repository_to_source_path

list_files.each do |file_path|
  copy_and_replace file_path
end

## --------------------------------------------------
## Instructions
## --------------------------------------------------
say "\n"
say 'Update your database.yml if you\'re not using the sqlite3 adapter, for example:'
say 'host: <%= ENV.fetch("DATABASE_HOST") %>'
say 'username: <%= ENV.fetch("DATABASE_USERNAME") %>'
say 'password: <%= ENV.fetch("DATABASE_PASSWORD") %>'
say "\n"
say "Don't forget to migrate the database :)"
say "rails db:migrate"
say "\n"
