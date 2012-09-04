gem 'twitter-bootstrap-rails', :group => :assets, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

%w(
  rspec-rails
  capybara
  spork
  factory_girl_rails
  simplecov
).each do |pkg|
    gem pkg, :group => :test
end

generate "bootstrap:install"
generate "rspec:install"

sed = <<EOS
sed -ie "6a\ require 'capybara/rspec'" spec/spec_helper.rb
EOS
run(sed)

run 'spork --bootstrap'
run 'echo "--drb" >> .rspec'


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
