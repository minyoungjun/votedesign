#coding:utf-8
class ElectorateController < ApplicationController

before_filter :is_logged_in

  def student_card
    sent_validation = Validation.where(:student_number => session[:student_number])

    if sent_validation.count == 0

      @sent = false
    else
      @sent = true
    end
  end

  def student_card_mail

    sent_validation = Validation.where(:student_number => session[:student_number])
    if sent_validation.count == 0
      validation = Validation.new
      validation.student_number = session[:student_number]
      validation.secure_token = SecureRandom.hex(10)
      validation.save
      @sent = false
    else
      validation = sent_validation.first
      validation.save
      @sent = true
    end
    
  end

end
