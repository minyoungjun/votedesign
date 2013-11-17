class Vote < ActiveRecord::Base
  belongs_to :admin
  has_many :options, :dependent => :destroy
  has_many :electorates, :dependent => :destroy
  has_many :attendants, :dependent => :destroy

  def vote_rate
    #재학중인 학생 수
    not_absent_student = self.electorates.where(:absent => false).count

    voted_not_absent_student = self.electorates.where(:absent => false, :voted => true).count
    
    #휴학생 중 투표한 사람 수
    voted_absent_student = self.electorates.where(:absent => true, :voted => true).count

    #투표한 학생 수
    voted_student = voted_not_absent_student + voted_absent_student

    #분모에 들어갈 값
    total_student = not_absent_student + voted_absent_student

    calculated_result = ((voted_student.to_f/total_student.to_f)*100).round(1)

    return [not_absent_student,voted_not_absent_student, voted_absent_student, calculated_result]

  end

  def vote_able_time
   if self.open_time <= Time.now.hour && Time.now.hour < self.close_time
     return true
   else
     return false
   end
  end

  def self.generate_code
    return Array.new(4){rand(10)}.join
  end

  def	votestart

    delta = self.start_time - Time.now
    return [0, 0, 0] if (delta < 0)

    dd = delta.to_i/60
    dd2 = dd/60

    return [dd2/24, dd2%24, dd%60]
  end

  def	votetimeout
    delta = self.end_time - Time.now
    return [0, 0, 0] if (delta < 0)

		dd = delta.to_i/60
		dd2 = dd/60

    return [dd2/24, dd2%24, dd%60]

	end

  def time_left_percent
    delta = self.end_time - Time.now
    return 0 if (delta < 0)

    whole_time = self.end_time - self.start_time
    left_percent = (100*delta.to_f/whole_time.to_f).round(0)
    return left_percent
  end

end
