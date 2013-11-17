require 'uri'
require 'json'
require 'open-uri'
require 'net/http'
require 'roo'
require 'zip/zip'

SNU_URL = "https://sso.snu.ac.kr/safeidentity/modules/auth_idpwd"

class Electorate < ActiveRecord::Base

  belongs_to :vote

  def self.snu_api_parse id, pw
    uri = URI.parse(SNU_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data({"method" => "json" , "si_id" => id, "si_pwd" => pw})
    response = http.request(req)
    
    parsed_res = JSON.parse(response.body)
    return parsed_res
  end

  def self.division_rate

    not_absent_student = self.where(:absent => false).count

    voted_not_absent_student = self.where(:absent => false, :voted => true).count
    
    voted_absent_student = self.where(:absent => true, :voted => true).count

    voted_student = voted_not_absent_student + voted_absent_student

    total_student = not_absent_student + voted_absent_student

    calculated_result = ((voted_student.to_f/total_student.to_f)*100).round(1)

    return calculated_result

  end

end
