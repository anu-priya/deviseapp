require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do

#localhost:3000
  importer :gmail, "718685077630-h9m14pcoirss71f3fma9a62rsfe1psqd.apps.googleusercontent.com", "gLwbpVu8xD4rNZHRTEXgWtQs", {:redirect_path => "/contacts/gmail/callback"}
  #importer :gmail, "517280994235.apps.googleusercontent.com", "QFtB2eY016-pVJvIgIU3xSLb", {:redirect_path => "/contacts/gmail/callback"}
  #importer :yahoo, "dj0yJmk9WEFzREpidHBJM1U5JmQ9WVdrOWR6bEViM0ZrTTJVbWNHbzlPRGswTVRBMU9EWXkmcz1jb25zdW1lcnNlY3JldCZ4PTgw", "c43984c5cac8b07431dc0a4f4ab7f04776bdca7f", {:callback_path => '/invites/yahoo/contact_callback'} 
  importer :yahoo, "dj0yJmk9eEtJelhLcGdlbUZyJmQ9WVdrOWQzWlNTRmxPTXpBbWNHbzlNVEkyTmpBME5qWTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1hMw", "834bc026171e0540a2f236657543189a593f82da", {:callback_path => '/invites/yahoo/contact_callback'} 
  importer :hotmail, "client_id", "client_secreat"																			
  importer :facebook, "421335961251817", "9e4f758989eb22a74655c52fbebf31d7", {:callback_path => '/contacts/facebook/contact_callback'} 

#dev.famtivity.com:8080
 # importer :gmail, "718685077630.apps.googleusercontent.com", "gM8tC39EQfpY1FYWzL5vPDnz", {:redirect_path => "/contacts/gmail/callback"}
 # importer :yahoo, "dj0yJmk9RzA1ZWFCQjVZaGpGJmQ9WVdrOU1qZDFTelJWTXpJbWNHbzlOVE0xT1RNME5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PTA1", "1908a3d7c75f8abff20e7e6c76cc04c6775ce71c", {:callback_path => '/invites/yahoo/callback'} 
 # importer :hotmail, "0000000048100C29", "YLF14Rn0I4BzOYRwG1Qr4e-ijMGyb3Cw"																	
 # importer :facebook, "367662280021164", "3fcfe4310ab67ffd40ba6a1f06e1fa86"

#famtivity.com
 # importer :gmail, "718685077630-ga0cre5un7u1dlacc03uu2o7lh5ac8vp.apps.googleusercontent.com", "tpmbvf0Oeu5VInO8bfgonz_N", {:redirect_path => "/contacts/gmail/callback"}
 # importer :yahoo, "dj0yJmk9VG9hMEFNZ2E1RDVCJmQ9WVdrOVVHRmhjMHRPTm1zbWNHbzlNakk1TmpFeE5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PWQw", "2a31722daf59ceeb1c128c215865482f4d6cfcd5", {:callback_path => '/invites/yahoo/callback'} 
 # importer :hotmail, "0000000048101B22", "Ba24Z2NGFCIVHXvGZ1jmyfBRTmZGh4jb"																	
 # importer :facebook, "403872903035404", "8c611d98772e2c31d3659b638c29a8a7"

end
