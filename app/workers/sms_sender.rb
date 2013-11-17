#coding:utf-8
class SmsSender
  include Sidekiq::Worker
  sidekiq_options :retry => false

  SMS_USER = "birdsil"
  SMS_PASSWORD = "qjemtlf"

  def perform(phone_number, validation_code)

    client = Savon.client(wsdl: 'http://webservice.tongkni.co.kr/sms.3/ServiceSMS.asmx?WSDL')

    h = Hash.new
    h["receivePhone"] = phone_number.split("-").join
    hash_value = Digest::MD5.hexdigest(SMS_USER + SMS_PASSWORD + h["receivePhone"])
    h["hashValue"] = hash_value
    h["smsID"] = SMS_USER
    h["senderPhone"] = phone_number
    h["smsContent"] = "[#{validation_code}] VOTEPEOPLE 인증번호입니다."

    res = client.call(:send_sms, :message => h)
  end

end
