class Admin < ActiveRecord::Base
  has_many :votes

  def self.new_admin 
    print "type admin name : "
    admin_name = gets.strip
    print "type passwod : "
    password = gets.strip
    print "type phone number : "
    phone_number = gets.strip

    admin = Admin.new
    admin.vote_id = -1
    admin.admin_name = admin_name
    admin.phone_number = phone_number
    admin.password = Digest::SHA512.hexdigest(password)
    admin.save
  end

  def refresh_password
    new_password = Array.new(6){(0..9).to_a.sample}.join
    self.password = Digest::SHA512.hexdigest(new_password)
    self.save
  end

end
