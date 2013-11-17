class InvitationController < ApplicationController

  def index
    
  end

  def save

    electorate = Guest.new
    #student는 college에 속합니다. college가 없으면 만들어줍니다.
    electorate.division = params[:college]
    #이미 있는 college이면 거기에 넣어줍니다.
    electorate.major = params[:major]
    electorate.realname = params[:realname]
    electorate.student_number = params[:student_number1] + "-" + params[:student_number2]
    electorate.phone = params[:phone1] + params[:phone2] + params[:phone3]
    electorate.save

    @realname = params[:realname]

  end
end
