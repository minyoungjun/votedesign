#coding: utf-8
class AdminController < ApplicationController

  before_filter :is_admin, :except => [:login, :login_process, :make_password, :attendant_password]
  
  
#[:index, :new_vote, :logout, :postpone_process, :postpone
#                                     :image_add, :image_change, :image_delete, :content_upload, :view,
#                                     :upload_electorate_list, :graph]
  MAX_PIC_SIZE = 4
  DIVISIONS = ["간호대학", "경영대학", "공과대학", "농업생명과학대학", "미술대학", "법과대학", "사범대학", "사회과학대학", "생활과학대학", "수의과대학", "약학대학", "음악대학", "의과대학", "인문대학", "자연과학대학", "자유전공학부", "치과대학"]


  def voted_list

    @division = params[:division]
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first

    if params[:voted] == "true"
      @boolean_voted = true
    else
      @boolean_voted = false
    end

    @electorate = @vote.electorates.where(:division => @division, :voted => @boolean_voted)
    @paginated_electorates = @electorate.order("student_number").paginate(:page => params[:page])

  end

  def vote_rate_detail

    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    @colleges_hash = Hash.new
    @colleges = DIVISIONS
    @colleges.each do |college|

      @colleges_hash[college] = @vote.electorates.where(:division => college)

    end

  end

  def student_card_list

  end
  
  def student_card_mail_send
    
    @validation = Validation.find(params[:id])
    @validation.mail_sent = true
    @validation.save

  end

  def student_card_cancel
    
    @validation = Validation.find(params[:id])
    @validation.delete

  end


  def postpone_process

    end_clock = if params[:noon] == "before" then params[:clock] else params[:clock].to_i + 12 end

    end_date = params[:due_date].split("-")

    end_time = Time.new(end_date[0], end_date[1], end_date[2], 
    end_clock.to_i, params[:minute].to_i)
                                  
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    @vote.end_time = end_time
    @vote.save
    redirect_to :action => "view",
                :controller => "admin",
                :id => @vote.id.to_s
                
  end

  def postpone

    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first

  end

  def destroy
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
  end

  def destroy_complete
    
    attendant_count = 0
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    all_attendants = @vote.attendants
    all_attendants.each do |attendant|
      if attendant.password == Digest::SHA512.hexdigest(params["password_" + attendant.id.to_s])
        attendant_count = attendant_count + 1
      end
    end
    if attendant_count == all_attendants.size
      @show = "show"
      DestroyData.perform_async(params[:vote_id])
    else
      @show = "no_show"
    end
  end
  def open_complete
    
    attendant_count = 0
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    all_attendants = @vote.attendants
    all_attendants.each do |attendant|
      if attendant.password == Digest::SHA512.hexdigest(params["password_" + attendant.id.to_s])
        attendant_count = attendant_count + 1
      end
    end
    if attendant_count == all_attendants.size
      @show = "show"
      @options = @vote.options
    else
      @show = "no_show"
    end
  end

  def password_validation
    if params[:open_boolean] == "true"
      @open_boolean = true
    else
      @open_boolean = false
    end
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
  end

  def mail_sent
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
  end

  def mail_sent_destroy
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
  end

  def make_password     
    @secure_token = params[:secure_token]
    attendant = Attendant.where(:vote_id => params[:vote_id], :secure_token => @secure_token)
    if attendant == nil
      render :text => "잘못된 접근입니다."
    else
      password_changer = attendant.first
      password_changer.password = Digest::SHA512.hexdigest(params[:password])
      password_changer.save
    end
  end

  def attendant_password
    @vote = Vote.find(params[:vote_id])
    @secure_token = params[:secure_token]
    attendant = Attendant.where(:vote_id => params[:vote_id], :secure_token => @secure_token)
    if attendant == nil
      render :text => "잘못된 접근입니다."
    else
      @attendant = attendant.first.email_address
    end

  end

  def mail_validation
    if params[:open_boolean] == "true"
      open_boolean = true
    else
      open_boolean = false
    end
    MailSender.perform_async(params[:id], open_boolean)
    if open_boolean
      redirect_to :action => "mail_sent",
                  :controller => "admin",
                  :id => params[:id].to_s
    else
      redirect_to :action => "mail_sent_destroy",
                  :controller => "admin",
                  :id => params[:id].to_s
    end
  end

  def open
    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
  end

  def index
    @votes = @admin.votes
  end

  def view

    @vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    @total_electorates = @vote.electorates
    @done_electorates = @vote.electorates.where(:voted => true)
    @paginated_electorates = @vote.electorates.order("division","student_number").paginate(:page => params[:page])

  end


  def change_able_time

    vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    vote.open_time = params[:open_time]
    vote.close_time = params[:close_time]
    vote.save
    redirect_to :back

  end

  def change_detail
  
    vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    vote.detail = params[:detail]
    vote.save
    redirect_to :back

  end


  def new_vote

    end_clock = if params[:noon] == "before" then params[:clock] else params[:clock].to_i + 12 end
    start_clock = if params[:start_noon] == "before" then params[:start_clock] else params[:start_clock].to_i + 12 end

    end_date = params[:due_date].split("-")
    start_date = params[:start_date].split("-")

    end_time = Time.new(end_date[0], end_date[1], end_date[2], 
                          end_clock.to_i, params[:minute].to_i)
    start_time = Time.new(start_date[0], start_date[1], start_date[2], 
                                  start_clock.to_i, params[:start_minute].to_i)
    vote = Vote.new
    vote.admin = @admin
    vote.content = params[:content]
    vote.end_time = end_time
    vote.start_time = start_time
    vote.open_time = params[:open_time]
    vote.close_time = params[:close_time]

    if params[:picture] != nil
      picture_name = SecureRandom.hex(5) + params[:picture].original_filename
      vote.picture_name = picture_name
      f = File.open(Rails.root.join("public", "images", picture_name), "wb")
      f.write(params[:picture].read)
      f.close
    end
    vote.save
    
    if params[:op] != nil
      params[:op].each do |x, y|
        if !x.empty?
          op = Option.new
          op.vote, op.name = vote, y
          op.save
        end
      end
    end

    if params[:em] != nil
      params[:em].each do |x, y|
        if !x.empty?
          att = Attendant.new
          att.vote, att.email_address = vote, y
          att.secure_token, att.password = SecureRandom.hex(10), SecureRandom.hex(10)
          att.save
        end
      end
    end

    redirect_to :action => "index"
  end

  def login

  end

  def login_process
    admin = Admin.where(:admin_name => params[:admin][:id]).first
    if !admin.nil? and (admin.password == Digest::SHA512.hexdigest(params[:admin][:password]))
      session[:admin_id] = admin.id
    end
    redirect_to :action => 'index'
  end

  def logout
    reset_session
    redirect_to :action => 'login'
  end



  def image_add
    if params[:file] != nil
      Option.find(params[:id]).pictures.size < MAX_PIC_SIZE
      Picture.save_picture  params[:file].original_filename, 
                            -1,  #As we make new picture, picture id is not assigned.
                            params[:id], 
                            params[:file].read
    end
    redirect_to :back
  end

  def image_change
    if params[:file] != nil
      Picture.save_picture  params[:file].original_filename, 
                            params[:pic_id],
                            -1, #Option id doesn't need to be changed.
                            params[:file].read
    end
    redirect_to  :back
  end

  def image_delete
    Picture.find(params[:id]).delete
    redirect_to :back
  end

  def content_upload
    option = Option.find(params[:id])
    option.person_first = params[:person_first]
    option.person_second = params[:person_second]

    option.public_content = params[:jing]
    option.self_content = params[:gong]
    option.save

    redirect_to  :back
  end

  def upload_electorate_list

    vote = Vote.where(:id => params[:id], :admin_id => @admin.id).first
    #Save
    excel_name = SecureRandom.hex(5) + ".xls"
    
    while Dir.glob(Rails.root.join("temporary_excel_file","*")).include? "temporary_excel_file/#{excel_name}"
      excel_name = SecureRandom.hex(5) + ".xls"
    end
    f = File.open(Rails.root.join("temporary_excel_file",excel_name), "wb")
    f.write(params[:file].read)
    f.close
    #Run!
    #Electorate.upload_list_xls params[:id], exnum
    ExcelUploader.perform_async(vote.id, excel_name)
    #Delete!
    #File.delete(Rails.root.join("public", "excel", exnum))
		redirect_to :back

  end

end
