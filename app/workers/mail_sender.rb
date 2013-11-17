#coding:utf-8
require 'rest_client'
class MailSender
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(vote_id, open_boolean)

		vote = Vote.find(vote_id)

		if open_boolean
			str = "개표"
		else
			str = "폐기"
		end

		vote.attendants.each do |attendant|
			addr = attendant.email_address
			cont = vote.content
			secure = attendant.secure_token
			my_vote_id = vote.id

      RestClient.post "https://api:key-5nqs9s-i5dyir4r0iv7md2u34s-vpy32"\
        "@api.mailgun.net/v2/votepeople.mailgun.org/messages",
        :from => "보트피플 <votepeople@votepeople.mailgun.org>",
        :to => addr,
        :subject => "#{cont} 전자투표 #{str} 확인 메일입니다.",
        :text => "#{cont}의 #{str}를 위한 당신만의 비밀번호를 설정해 주십시오. 모든 비밀번호가 한자리에 모였을 때 #{str}가 가능합니다. 아래 링크로 들어가면 비밀번호 설정이 가능합니다. https://vote.snu.ac.kr/admin/attendant_password?vote_id=#{my_vote_id}&secure_token=#{secure}"
    end
  end
end
