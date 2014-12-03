class MessageThreadViewer < ActiveRecord::Base
attr_accessible :read_status, :user_id
belongs_to :message_thread
 scope :find_unread_count, lambda { |id| where("user_id=? and read_status=? and msg_thread_flag=?",id,false,true) }
end