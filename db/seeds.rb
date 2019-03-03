# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Dog.delete_all
User.delete_all
Like.delete_all
# ActiveRecord::Base.connection.reset_sequence!('dogs')
# ActiveRecord::Base.connection.reset_sequence!('users')
# ActiveRecord::Base.connection.reset_sequence!('likes')

dogs = [
  {
    name: 'Bowie',
    description: 'Bowie dances when he walks'
  },
  {
    name: 'Brownie',
    description: 'Brownie only sits pretty'
  },
  {
    name: 'Jax',
    description: '',
  },
  {
    name: 'Jiro',
    description: 'Jiro takes a long time to destroy his toys'
  },
  {
    name: 'Pete',
    description: 'Pete has a best friend named Lua'
  },
  {
    name: 'Bijou',
    description: 'Bijou is the fluffiest of them all'
  },
    {
    name: 'Britta',
    description: 'Britta has two different colored eyes'
  },
  {
    name: 'Noodle',
    description: 'Noodle is an Instagram celebrity'
  },
  {
    name: 'Stella',
    description: 'Stella loves to dig'
  },
  {
    name: 'Tonks',
    description: 'Tonks loves to run'
  },
]

user = User.create!(email: 'jeff@jeff.com', password: '111111', password_confirmation: '111111')

dogs.each do |dog|
  dog = Dog.find_or_create_by(name: dog[:name], description: dog[:description], owner_id: user.id)
  directory_name = File.join(Rails.root, 'db', 'seed', "#{dog[:name].downcase}", "*")

  Dir.glob(directory_name).each do |filename|
    if !dog.images.any?{|i| i.filename == filename}
      dog.images.attach(io: File.open(filename), filename: filename.split("/").pop)
      sleep 1
    end
  end
end
