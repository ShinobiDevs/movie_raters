# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Movie.destroy_all

Movie.create(name: "Godfather", genres: "drama,crime", year: 1970)
Movie.create(name: "Stepup", genres: "bullshit,throw up", year: 2006)
Movie.create(name: "Bambi", genres: "children, drama", year: 1931)

User.create(email: "test1@movierater.com", name: "tester one")
User.create(email: "test2@movierater.com", name: "tester two")
User.create(email: "test3@movierater.com", name: "tester three")