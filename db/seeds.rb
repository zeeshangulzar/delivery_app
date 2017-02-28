# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all

User.create!([
  {id: 1, name:"Touqeer", email:"touqeer@gmail.com", password:"123456", cell:"+923001234567", verified: false, verified_token: nil, role:"consumer"},
  {id: 2, name:"Ahmad", email:"ahmad@gmail.com", password:"123456", cell:"+923111234567", verified: false, verified_token: nil, role:"consumer"},
  {id: 3, name:"Ali", email:"ali@gmail.com", password:"123456", cell:"+923221234567", verified: false, verified_token: nil, role:"consumer"},
  {id: 4, name:"Zeshan", email:"zeshan@gmail.com", password:"123456", cell:"+923331234567", verified: false, verified_token: nil, role:"consumer"},
  {id: 5, name:"Admin1", email:"admin1@gmail.com", password:"123456", cell:"+923441234567", verified: true, verified_token: nil, role:"admin"}
])
