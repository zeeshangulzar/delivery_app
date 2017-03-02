# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AuthenticationToken.delete_all
SocialLogin.delete_all
User.delete_all

User.create!([
  {id: 1, name:"Touqeer", email:"touqeer@gmail.com", password:"123456", cell:"+923001234567", role:"consumer"},
  {id: 2, name:"Ahmad", email:"ahmad@gmail.com", password:"123456", cell:"+923111234567", role:"consumer"},
  {id: 3, name:"Ali", email:"ali@gmail.com", password:"123456", cell:"+923221234567", role:"consumer"},
  {id: 4, name:"Zeshan", email:"zeshan@gmail.com", password:"123456", cell:"+923331234567", role:"consumer"},
  {id: 5, name:"Admin", email:"admin1@gmail.com", password:"123456", cell:"+923441234567", verified: true, role:"admin"}
])

SocialLogin.create!([
  {id: 1, platform_name:"facebook", authentication_id:"fb1", user:User.find(1)},
  {id: 2, platform_name:"gmail", authentication_id:"g1", user:User.find(1)},
  {id: 3, platform_name:"facebook", authentication_id:"fb2", user:User.find(2)},
  {id: 4, platform_name:"facebook", authentication_id:"fb3", user:User.find(3)},
  {id: 5, platform_name:"hotmail", authentication_id:"h1", user:User.find(4)}
])
