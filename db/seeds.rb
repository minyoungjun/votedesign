#coding:utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Admin.new
admin.vote_id = -1
admin.admin_name = "admin"
admin.admin_realname = "제 56대 총학생회 선거관리위원회"
admin.phone_number = "010-5503-9353"
admin.password = Digest::SHA512.hexdigest("cjstjr@alsdud123")
admin.save


