Rails.application.config.middleware.use OmniAuth::Builder do
 # provider :facebook, '421335961251817', '9e4f758989eb22a74655c52fbebf31d7', {:scope => 'publish_stream,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}

# localhost for rajkumar system only 10.37.4.127:3000/
  provider :facebook, '421335961251817', '9e4f758989eb22a74655c52fbebf31d7'

#  Famtivity.com 
#  provider :facebook, '403872903035404', '8c611d98772e2c31d3659b638c29a8a7'

#  staging Server 54.243.133.232
#  provider :facebook, '367662280021164', '3fcfe4310ab67ffd40ba6a1f06e1fa86'

end

