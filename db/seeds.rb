# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def generate_token
  loop do
    token = SecureRandom.urlsafe_base64().tr('-_', '')[0..3].downcase
    break token unless User.where(password: token).exists?
  end
end

for i in 0..99 do
  User.create(password: generate_token, greeting: generate_token).save
end
