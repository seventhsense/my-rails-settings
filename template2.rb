# gem 'twitter-bootstrap-rails', :group => :assets, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'twitter-bootstrap-rails', :group => :assets
gem 'simple_form'
gem 'country_select'


gem 'cucumber-rails', "~> 1.0", require: false,group: :test
gem 'rb-inotify', '~> 0.8.8',group: :test

%w(
  rspec-rails
  capybara
  database_cleaner
  spork
  guard
  guard-spork
  guard-rspec
  guard-cucumber
  factory_girl_rails
  simplecov
).each do |pkg|
    gem pkg, :group => :test
end

generate "bootstrap:install"
generate "simple_form:install --bootstrap"

generate "rspec:install"
generate "cucumber:install --spork"

sed = <<EOS
sed -ie "6a\ require 'capybara/rspec';
require 'simplecov';
require 'SimpleCov.start 'rails'" spec/spec_helper.rb
sed -ie "36a\     config.time_zone = 'Tokyo'" config/application.rb
sed -ie "41a\     config.i18n.default_locale = :ja" config/application.rb
EOS
run sed
run 'wget https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -P config/locales/'

run 'spork --bootstrap'
run 'echo "--drb" >> .rspec'

run 'bundle exec guard init spork'
run 'bundle exec guard init cucumber'
run 'bundle exec guard init rspec'

sed = <<EOS
sed -ie "16d" Guardfile
sed -ie "15a\ guard 'cucumber',cli: '--drb' do" Guardfile
sed -ie "22d" Guardfile
sed -ie "21a\ guard 'rspec',version: 2,cli: '--drb' do" Guardfile
EOS
run sed


puts "--------------------removing unneeded files...--------------------"
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm app/assets/images/rails.png'
run 'touch README.mkd'

puts "--------------------checking everything into git...--------------------"
git :init
git :add => '.'
git :commit => "-m 'initial commit'"

puts "--------------------Git initial commit done.--------------------"

# run 'spork &'

# puts ''
# puts '-------------------Running spork in Background process--------------------'
# puts 'if you want to stop the spork process, use kill command'


message = <<EOS
Now All ready

Todo next
1 cd Apprication root
2 bundle exec spork
3 rails g bootstrap:layout application fixed
4 rails g bootstrap:themed [Resource_name]
5 rails g factory_girl:model Model scheme --dir=spec/factories


EOS
puts message
