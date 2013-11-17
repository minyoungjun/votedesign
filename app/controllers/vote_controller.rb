#coding:utf-8
class VoteController < ApplicationController

  before_filter :is_logged_in, :except => [:login, :login_process]

  def index
    today = Time.new
    @votes = Vote.where("start_time <= ? AND end_time >= ?", today, today)
  end

  def view
    
    @vote = Vote.where(:id => params[:id]).first
    @electorate = @vote.electorates.where(:student_number => session[:student_number]).first
    if @electorate == nil
      redirect_to :action => "index"
    end
  end

  def send_validation_code
    session[:validation_code] = Vote.generate_code
    SmsSender.perform_async(session[:phone_number], session[:validation_code])
    render :json => {:result => true}
  end

  def phone #sms_check

	  @option = Option.find(params[:id])   

    if Electorate.where(:vote_id => @option.vote_id).where(:student_number => session[:student_number]).first.voted != true
      @phone_number = session[:phone_number]
	    session[:validation_code] = Vote.generate_code
      session[:phone_code_time] = Time.now
	    SmsSender.perform_async(session[:phone_number], session[:validation_code])
    else
      render :text => "이미 투표하셨습니다."
    end
  end

  def phone_error

  end


  def code_input
	  @option = Option.find(params[:id])   
    validation = Validation.where(:student_number => session[:student_number], :mail_sent => true)
    if Electorate.where(:vote_id => @option.vote_id).where(:student_number => session[:student_number]).first.voted != true
      if validation.count == 0
        @validated = false
      else
        @validated = true
        session[:validation_code] = validation.first.secure_token
      end
    else
      render :text => "이미 투표하셨습니다."
    end
  end

  def done
    if session[:student_number].nil? or session[:validation_code].nil?
      render :text => "ERROR"
    elsif session[:validation_code] != params[:validation_code] || Time.now - session[:phone_code_time] > 180
      redirect_to :action => "phone_error"
    else
      ###########LOCK######################LOCK###########
      #ActiveRecord::Base.connection.execute("LOCK TABLES options WRITE")
      #ActiveRecord::Base.connection.execute("LOCK TABLES electorates WRITE")
     
      @option = Option.where(:id => params[:id]).first
      @electorate = Electorate.where(:vote_id => @option.vote_id, 
                                      :student_number => session[:student_number]).first

      @vote = Vote.find(Option.find(params[:id]).vote_id)
      #@option.score = @option.score + 1
      count = Count.new
      count.option_id = params[:id]
      count.vote_id = @option.vote_id

      if @electorate.voted == false && @vote.vote_able_time && @vote.votestart == [0, 0, 0]&& @vote.votetimeout != [0, 0, 0]
        @electorate.voted = true
        ActiveRecord::Base.transaction do
          #@option.save!
          count.save
          @electorate.save!
        end
        student_number = session[:student_number]
        phone_number = session[:phone_number]
        reset_session
        session[:student_number] = student_number
        session[:phone_number] = phone_number
        session[:login] = true
      else
        render :text => "투표하실 수 없습니다. 이미 투표하셨거나, 투표가능 시간이 아니거나, 마감된 투표입니다."
      end
      ##########UNLOCK####################UNLOCK##########
      #ActiveRecord::Base.connection.execute("UNLOCK TABLES")
    end
  end

  def login_process
    parsed = Electorate.snu_api_parse params[:login][:id], 
                                      params[:login][:password]
    logger.info parsed.inspect
    if parsed["SA_UID"].nil?
      reset_session
      session[:agreement], session[:login] = true, false
      redirect_to :action => 'login'
    else
      reset_session
      session[:agreement], session[:login] = false, true
      session[:student_number] = parsed['SA_gr1memberkey']
      session[:phone_number]  = parsed['SA_mobile']
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session 
    redirect_to :action => 'login'
  end

end
