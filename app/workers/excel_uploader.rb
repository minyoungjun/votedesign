#coding:utf-8
require 'uri'
require 'roo'
require 'zip/zip'
class ExcelUploader
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform vote_id, exnum
    
		ex = Roo::Excel.new(Rails.root.join("temporary_excel_file", exnum).to_s)
		ex.default_sheet = ex.sheets[0]
		count = 2
		vote = Vote.find(vote_id)

		while( ex.cell(count, 'B') != nil && ex.cell(count, 'B') !="")
			if Electorate.where(:vote_id => vote_id).where(:student_number => ex.cell(count, 'B')).size == 0
				electorate = Electorate.new
				electorate.vote_id = vote_id
        electorate.division = ex.cell(count, 'A')
				electorate.student_number = ex.cell(count, 'B')
				electorate.realname = ex.cell(count, 'C')
        if ex.cell(count, 'D') == "재학"
          electorate.absent = false
        else
          electorate.absent = true
        end
				electorate.voted = false
				electorate.save
      end
      count = count + 1
    end
    File.delete(Rails.root.join("temporary_excel_file",exnum))
  end

end
