class Option < ActiveRecord::Base
  belongs_to :vote
  has_many :pictures, :dependent => :destroy
	has_many :counts, :dependent => :destroy
end
