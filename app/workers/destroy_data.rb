#coding:utf-8
class DestroyData
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(vote_id)

    Vote.find(vote_id).destroy

  end
end
