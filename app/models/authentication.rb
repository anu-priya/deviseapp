class Authentication < ActiveRecord::Base
  attr_accessible :user_id, :provider, :uid, :token
  belongs_to :user

 validates :user_id, :uid, :provider, :presence => true
 validates_uniqueness_of :uid, :scope => :provider
 
belongs_to :contact_user
belongs_to :user

def self.find_by_provider_and_uid(provider, uid)
  where(provider: provider, uid: uid).first
end
def facebook
  @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
end

#def provider_name
 #   if provider == 'open_id'
  #    "OpenID"
   # else
    #  provider.titleize
    #end
  #end

end
