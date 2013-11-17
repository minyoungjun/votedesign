class Picture < ActiveRecord::Base

  def self.save_picture original_filename, pic_id, option_id, file

    img = if pic_id == -1 then Picture.new else Picture.find(pic_id) end
    img.saved_name = SecureRandom.hex(5) + original_filename
    img.option_id = option_id if option_id != -1
    img.save

    f = File.open(Rails.root.join("public", "images", img.saved_name), "wb")
    f.write(file)
    f.close

  end

end
