require 'uri'
Famtivity::Application.routes.draw do

  resources :admin_discount_codes


  resources :fam_posts


  resources :fam_network_posts


  resources :fam_network_groups


  resources :fam_networks


  resources :user_children

  resources :participant_agerange_colors

  resources :activity_prices

  resources :agerange_colors do
    get :age_range_create
  end

  resources :settings

  resources :policies

  resources :user_transactions  

  resources :monthly_budgets

  resources :activity_bids

  resources :user_profiles do
    collection do
      get :down_sponcer
      get :provider_sponsor
      get :up_sponcer
      get :up_sell
      get :provider_payment_details
      get :invite_friends
  
    end
  end

  resources :users 

  resources :participants do
    get :participant_destroy
  end
  resources :invites
  #~ Discount dollars routes
  resources :discount_dollars
  
  
  #Messaging functionality  
  resources :messages

  #User Settings routes added new
  match 'change_password' => 'parent_settings#change_password'
  match 'update_userpassword' => 'parent_settings#update_userpassword'
  match 'parent_settings' => 'parent_settings#parent_settings'
  match 'create_parent_settings' => 'parent_settings#create_parent_settings'
  match 'provider_settings' => 'provider_settings#provider_settings'
  match 'create_provider_settings' => 'provider_settings#create_provider_settings'
  match 'provider' => 'provider_settings#index'
  match "provider_activites"=>"provider_settings#provider_activites"
  match 'provider_basic_search'=>'provider_settings#provider_basic_search'
  match 'search_index'=>'provider_settings#search_index'
  match "provider_activity_discount"=>"discount_dollars#provider_activity_discount"
  match "edit_discount_type"=>"discount_dollars#edit_discount_type"
  match "update_discount_type"=>"discount_dollars#update_discount_type"
  match "delete_discount"=>"discount_dollars#delete_discount"
  match "discount_destroy"=>"discount_dollars#discount_destroy"
  match "provider_discount_type"=>"discount_dollars#provider_discount_type"
  #Parent Profile 
  match 'parent_profile' => 'parent_settings#parent_profile'
  match 'parent/parent_profile' => 'parent_settings#parent_profile'
  match 'parent_edit_profile' => 'parent_settings#parent_edit_profile'
  match 'parent_update_profile' => 'parent_settings#parent_update_profile'
  match 'participant_destroy' => 'parent_settings#participant_destroy'
  #Search SEO Functionality
  #~ resources :search
  match 'search'=>'search#search_new_search'
  get 'activity_provider_list_res' => 'admin#activity_provider_list_res'
  match 'activity_provider_list' =>'admin#activity_provider_list'
  post 'users/check_discount_code'
  post '/messages/new'
  post '/contact_groups/frinds_networks'
  post 'admin_discount_codes/delete_discount_code'
  post "admin_discount_codes/update_discount_codes"
  post "admin_discount_codes/create_discount_codes"
  match "update_discount_active_status" =>'admin_discount_codes#update_discount_active_status'
  match 'admin_delete_discount'=>'admin_discount_codes#admin_delete_discount'
  match 'edit_discount' => "admin_discount_codes#edit_discount"
  match 'discount_codes' => 'admin_discount_codes#index'
  match 'reply_fam_post' => 'fam_network_posts#reply_fam_post'
  match 'delete_fam_post' => 'fam_network_posts#delete_fam_post'
  match 'download_network_post_files'=>'fam_network_posts#download_network_post_files'
  match 'accept_fam_network'=> 'fam_networks#accept_fam_network'
  match 'fam_network_detail' =>'fam_networks#fam_network_detail'
  match 'fam_network' =>'fam_network_groups#fam_network'
  get 'create_network' => 'fam_network_groups#create_network'
  get 'remove_member'=>'fam_network_groups#remove_member'
  match 'fam_create_post'=> 'fam_networks#fam_create_post'
  match 'add_to_temp_fampost' => 'fam_network_posts#add_to_temp_fampost'
  match 'create_fam_post' => 'fam_network_posts#create_fam_post'
  match 'reply_fam_post' => 'fam_network_posts#reply_fam_post'
  match 'delete_fam_post' => 'fam_network_posts#delete_fam_post'
  match 'fam_edit_network_group'=>'fam_network_groups#fam_edit_network_group'

  match 'add_to_temp' => 'messages#add_to_temp'
  match 'message_thread_listing' => 'messages#message_thread_listing'
  match 'chat_reply' => 'messages#chat_reply'
  match 'message_delete' => 'messages#message_delete'
  match 'message_thread_delete' => 'messages#message_thread_delete'
  get 'reply_message_form' => 'messages#reply_message_form'
  match 'reply_message_create' => 'messages#reply_message_create'
  match 'download_message_files' => 'messages#download_message_files'
  match 'get_group_users' => 'messages#get_group_users'
  match 'zip_search' =>"landing#zip_search"
  #~ match 'provider_add_message' => 'messages#provider_add_message'
  #~ match 'parent_add_message' => 'messages#parent_add_message'
  #Messaging functionality
  match 'search_msg'  => 'messages#search_msg'
  
  get 'landing/category_report_count'
  get 'landing/famtivity_user_count' 
  match "ttesting"=>"landing#testing"
  #match "provider_activity_discount"=>"activity_detail#provider_activity_discount"
  match 'add_files_to_temp' => 'contact_users#add_files_to_temp'
  match 'provider_web_count' => "activities#provider_web_count"
  
  #Auto populating data for autocomplete
  match 'user_tags' => 'user_profiles#user_tags'
  match 'activity_tags' => 'activities#activity_tags'
  match 'populate_email' => 'contact_users#populate_email'
  match 'message_email' => 'messages#message_email'
  match 'fetch_city' => 'user_profiles#fetch_city'
 
  #invite success page added by dayanthan nov-20
  match "invite_success_page"=>"contact_users#invite_success_page"
  match "change_email"=>"user_profiles#change_email"
  match "change_email_address"=>"user_profiles#change_email_address"
  match 'email_activate' => 'user_profiles#email_activate'

  match "user_activity_status"=>"activities#user_activity_status"
  match "new_success_page"=>"activities#new_success_page"
  match "activity_category_report"=>"landing#activity_category_report"
  match "famtivity_user_report"=>"landing#famtivity_user_report"
  match "find_us_on_famtivity"=>"landing#find_us_on_famtivity"
  get "/contacts/facebook/callback" => "contact_users#facebook_contact_list"
  get "/contacts/gmail/callback" => "contact_users#contact_list" 
  get "/contacts/yahoo/callback" => "contact_users#contact_list"
  get "/contacts/hotmail/callback" => "contact_users#contact_list"
  get "/contacts/failure" => "contact_users#contact_fail"
  match "fb_invite"=>"contact_users#fb_invite"

  match "invite-friend(/:login)"=>"contact_users#newslertter_invite"
  match "invite-famnetwork(/:news_letter_fam)"=>"contact_users#newslertter_fam_network"
  match '/invite-friends(/:invite_login)' => 'landing#landing_new'
  match 'invite-famnetworks(/:famnet_login)' => 'landing#landing_new'
  match '/invite-friends/login(/:u)' => 'login#login'
  match '/invite-famnetworks/login(/:u)' => 'login#login'
  post "activity_detail/send_edit_mail"
  

  #get "/contacts/hotmail/callback" => "contact_users#contact_list"
  #get "/invites/:provider/contact_callback" => "invites#index"
  #match "/blog" => redirect("/contacts/facebook"), :as => :blog
  #~ match '/:city-ca/:categ/:sub_categ/:busi_name' => 'landing#follow_cities'
  #~ match 'cities/:data(/:city(/:categ(/:sub_categ(/:busi_name(/:user)(/:det_user_id)))))' => 'landing#follow_cities'
  #~ match 'city/:data(/:city(/:profile_id))' => 'landing#follow_provider_card'
  #provider_terms
  match 'provider_terms(/:act_name(/:pid))' => 'policies#provider_terms'

  #School Representative
  resources :school_representatives
  match "represented_details" => "school_representatives#represented_details"
  match "activate_representative_activity" => "school_representatives#activate_representative_activity"
  match "update_schoolrep_status" => "school_representatives#update_schoolrep_status"
  match "vendor_permission_update" => "school_representatives#vendor_permission_update"
  match "checkForBusinessName" => "school_representatives#checkForBusinessName"
 
  #Activity Network
  match 'invite_attendees_accept' => 'activity_network#invite_attendees_accept'
  match 'offline_participant_add' => 'activity_network#offline_participant_add'
  match 'attendees_destroy' => 'activity_network#attendees_destroy'
  match "invite_attend" => "activity_network#invite_attend"
  match "activity_network" => "activity_network#activity_network"
  match "participant_message" => "activity_network#participant_message"
  match "participant_message_success" => "activity_network#participant_message_success"
  match "invite_manager" => "activity_network#invite_manager"
  match "invite_manager_accept" => "activity_network#invite_manager_accept"
  match "fampass_accept" => "activity_network#fampass_accept"
  match "network_next_prev_details" => "activity_network#network_next_prev_details"
  match "search_attend_detail" => "activity_network#search_attend_detail"
  match "assigned_manager" => "activity_network#assigned_manager"
  match "assign_manager_accept" => "activity_network#assign_manager_accept"
  match "permission_managers" => "activity_network#permission_managers"
  match "sort_attend_list" => "activity_network#sort_attend_list"
  match "invite_manager_exist" => "activity_network#invite_manager_exist"
  
  match "resend_activation" => "users#resend_activation_link"
  
  get 'landing/get_total_count_feature_list'
  get 'landing/get_total_count_my_activity_list'
  get 'landing/get_total_favorite_count_list'
  get 'landing/get_total_count_shared_list'
  get 'landing/get_total_count_free_list'
  get 'landing/get_total_count_sub_category_list'

  get 'landing/free_activity'
  get 'landing/featured_activity'
  #get 'landing/featured_activity_detail'
  get 'landing/provider_names_list'
  get 'landing/cat_subcategory_row'
  get 'landing/shared_activity'
  get 'landing/favorite_activity'
  get 'landing/my_activity'
  get 'landing/get_parent_user'
  get 'landing/get_provider_user'
  
  get "/login/fb_login"
  get "activities/edit_update_sub_category"
  get '/checkout/get_participant'
  get 'activities/testing'
  get "activities/edit_update_sub_category"
  get 'activity_subcategories/update_follow_row'
  get 'activity_subcategories/get_follow_user'
  get 'activity_subcategories/update_user_category'
  get '/per_ad/:id' => "user_profiles#per_ad", :as => :per_ad
  post "landing/contact_us_mail"
  get "sponsor_ships/billing_sponsorship_update"
  get "sponsor_ships/location_based_activity"
  get "activity_subcategories/update_sub_category"
  get "checkout/secure_checkout"
  get "checkout/proceed_to_checkout"
  post "checkout/checkout_thank"
  get "activity_detail/ticket"
  get "activity_detail/share_activity_favthank"
  get "activity_detail/share_activity_thank"
  get "activity_detail/edit_acitivity_thank"
  get "activity_detail/parent_acitivity_thank"
  get "activity_detail/activity_email_link"
  get "activity_detail/embedded_link"
  #~ Provider embedded link start
  get "activity_detail/provider_embedded_link"
  #~ get "activity_detail/find_us_on_famtivity_popup"
  match "find-us-on-famtivity" =>"activity_detail#find_us_on_famtivity_popup"
  match "/activity_detail/find_us_on_famtivity_popup", :to =>redirect("/activity_detail/find-us-on-famtivity")
  match "/preview_embed_popup" => "activity_detail#preview_embed_popup"
  match "/embed_popup" => "activity_detail#embed_popup"
  match "activity_embed" => "embed#activity_embed"
 

  #end 
  get "activities/add_participant"
  get "activity_detail/schedule_price" 
  get "activities/delete_activity"
  #get "activity_detail/delete_discount"
  get "activities/shedule_delete"
  get "activities/delete_activity_empty"
  get "/activity/add_to_favourite"
  get "/contact_users/contact_detail"
  post "checkout/add_participant_success"
  post "contact_users/contact_create"
  post "contact_users/contact_edit"
  post "contact_users/contact_update" 
  #~ post "policies/policy_update"
  post "provider_settings/policy_update"
  get "contact_users/delete"
  get "contact_users/delete_empty"
  get "contact_users/select_mail"
  get "contact_users/select_mail_empty"
  post "contact_users/req_multi_email"
  post "users/curated_user_exist"
  post "activity_detail/provider_fee"
  post "activity_detail/provider_discount_fee"
  post "activity_detail/delete_provider_fee"
  post "activity_detail/delete_provider_discount_fee"
  post "activity_detail/update_provider_fee"
  post "activity_detail/update_discount_provider_fee"
  #post "activity_detail/provider_discount_type"
  post "activity_detail/create_discount_type"
  post "activity_detail/create_first_discount_type"
  #~ post "contact_users/index"
  post "contact_users/destroy"
  post "activities/destroy"
  #post "activity_detail/discount_destroy"
  post "activities/schedule_destroy"
  post "participants/destroy"
  post "checkout/secure_checkout_success"
  post "users/user_exist"
  get "admin/index_update"
  match 'search_admin_index'=>'admin#search_admin_index'
  get "admin/delete_activity"
  get "admin/delete_activity_empty"
  post "admin/destroy"
  post "admin/mark_featured"
  post "admin/raise_flag_update"
  post "activities/check_activity_status"
  post "activity_favorites/add_favorite"
  post "activity_favorites/add_calender"
  post "activity_favorites/add_famtivity_calender"
  get "activity_favorites/favorite_exist"
  get "search/data_entry"

  match 'data_entry' => "search#data_entry"
  match 'email_activity_success'=>'activity_detail#email_activity_success'
  match "provider_bid_amount"=>"users#provider_bid_amount"
  get "activity_schedules/get_sched_cal"
  get "activity_schedules/get_provider_cal"
  get "sponsor_ships/delete_bid"
  match 'scheduledel'=>'activities#scheduledel'
  match 'shedule_delete' =>'activities#shedule_delete'
  
  #match 'activity_detail_page' =>'activity_detail#activity_detail_page'
  match 'activitydetail_new' =>'activity_detail#activitydetail_new'
  #changed activity detail iframe to activities SEO
  #~ match 'activities(/:det(/:city(/:mode(/:category(/:sub_category(/:activity_name))))))' =>'activity_detail#activities'
  #~ match 'activities(/:det(/:city(/:mode(/:category(/:sub_category)))))' =>'activity_detail#activities'
  match 'activity_share/:det/:mode/:act' => 'activity_detail#activities'
  #~ match 'activities' =>'activity_detail#activities' 
  match 'activity_detail_iframe' =>'activity_detail#activity_detail_iframe' #~ activity_detail_iframe
  match 'activity_detail_iframe(/:det)' =>'activity_detail#activity_detail_iframe' #~ activity_detail_iframe
  #added routing for tweet 
  #~ match 'activities(/:det)' =>'activity_detail#activities'
  match 'provider_detail_iframe' =>'activity_detail#provider_detail_iframe'
  #SEO URL FIXES
  #match 'provider_info(/:business_name(/:det))' => 'activity_detail#provider_info' #old url
  #~ match "/provider_info/:business_name/:det" => redirect {|params,req| "/provider-info/#{params[:business_name]}/#{params[:det]}"} #new url
  #~ match 'provider-info(/:business_name(/:det))' => 'activity_detail#provider_info' #new url
  match 'provider-details(/:city(/:business_name))' => 'activity_detail#provider_info' #new url
  match "/provider-info/:business_name/:det" => redirect {|params,req| "/provider-card/#{params[:business_name]}"} #new url
  
  #Google Calendar
  match 'googleCalAdd' =>'activity_detail#googleCalAdd'

  #newsletter template
  match 'newsletter_template' => 'newsletters#newsletter_template'
  match 'weekend_template' => 'newsletters#weekend_template'
  match 'weekend_activities' => 'newsletters#weekend_activities'

  #newsletter activitydetails link
  #match 'activitydetails' =>'activity_detail#activity_detail_news'
  match 'provider_information' => 'activity_detail#provider_information'
  match 'contact_provider_info' => 'activity_detail#contact_provider_info'
  match 'contact_provider_success'=>'activity_detail#contact_provider_success'
  match 'share_activity' =>'activity_detail#share_activity'
  match 'edit_activity'=>'activity_detail#provider_edit_activity'
  match 'edit_activity_parent'=>'activity_detail#edit_activity_parent'
  match 'share_activity_success'=>'activity_detail#share_activity_success'
  match 'provider_activity_success'=>'activity_detail#provider_activity_success'
  match 'provider_edit'=>"activity_detail#provider_edit"
  match 'link_clicked'=>"activity_detail#link_clicked"
  match 'sendmsgtoprver'=>"activity_detail#sendmsgtoprver"
  match 'bid_create'=>'sponsor_ships#bid_create'
  match 'bid_update'=>'sponsor_ships#bid_update'
  match 'sched'=>'activity_schedules#sched'
  match 'admin_gallery'=>'admin#admin_gallery'
  match 'admin'=>'admin#index'
  match 'admin_user_list'=>'admin#admin_user_list'
  get 'activities/update_index'
  get 'activities/update_shared'
  match 'activities_index'=>'activities#activities_index'
  match 'update_ses_date' =>  'landing#update_ses_date'
  match 'update_parent_provider' => 'landing#update_parent_provider'
  match 'tell_us_yourself' => 'landing#tell_us_yourself'
  match 'blog_video' => 'landing#blog_video'
  match 'splash' => 'landing#splash'
  match 'attendies' => 'activity_attend_details#attendies'
  match 'down_free' => 'user_profiles#down_free'
  match 'provider_sell_upgrade' => 'user_profiles#provider_sell'
  match 'provider_plan_upgrade' => 'user_profiles#provider_plan_upgrade'
  match 'provider_plan_downgrade' => 'user_profiles#provider_plan_downgrade'
  match 'provider_plan_upgrade_tran' => 'user_profiles#provider_plan_upgrade_tran'
  match 'provider_plan_submit_tran' => 'user_profiles#provider_plan_submit_tran' 
  match "user_account_delete"=>"user_profiles#user_account_delete"
  match "user_account_deactivate"=>"user_profiles#user_account_deactivate"
  match 'provider_plan_renewaling' => 'user_profiles#provider_plan_renewaling' 
  match 'upgradePlan' => 'user_profiles#upgradePlan'
  match 'plan_success_message' => 'user_profiles#plan_success_message'
  match 'register_status_message' => 'users#register_status_message'
  match 'provider_list_count_top' => 'users#provider_list_count_top'
  match "user_activates_list"=>"users#user_activates_list"
  match "user_activate_details"=>"users#user_activate_details"
  
  #for curator update plan rajkumar nov 21
  match 'provider_curator_upgrade' => 'user_profiles#provider_curator'
  match 'up_curator'=> 'user_profiles#up_curator'
  #match 'test' => 'activity_detail#test'
  
  
  #~ match 'provider_sell' => 'user_profiles#provider_sell'
  match 'footercity' => 'landing#footercity'
  match 'msg_to_provider_curator'=>"activity_detail#msg_to_provider_curator"
  get "admin/provider_curator"
  post "admin/raise_flag_provider_update"
  #16July13 Scroll fix update revised routes
  #get 'landing/free_activity' 
  #get 'landing/featured_activity' 
  #get 'landing/cat_subcategory_row' 
  #get 'landing/shared_activity' 
  #get 'landing/favorite_activity' 
  #get 'landing/my_activity' 
  #get 'landing/get_parent_user' 
  #get 'landing/get_provider_user'
  
  #~ To send mail manually
  match 'activate_email' => 'users#activate_email'
  #~ match 'bank_info' => 'users#bank_info'
  match 'bank_info' => 'provider_settings#bank_info'
  #~ match 'get_credit_card_info' => 'user_transactions#get_credit_card_info'
  match 'get_credit_card_info' => 'provider_settings#get_credit_card_info'
  #~ match 'update_credit_card_info' => 'user_transactions#update_credit_card_info'
  match 'update_credit_card_info' => 'provider_settings#update_credit_card_info'
  #~ match 'updatebank_details' => 'users#updatebank_info'
  match 'updatebank_details' => 'provider_settings#updatebank_info'
  match 'newsletter_subscripe' => 'landing#newsletter_subscripe'
  
  #-----------------------------------------
  # url changes from event to provider
  match 'provider' => 'activities#index'
  match "raja" =>"activities#raj_update"
  #landing page
  match 'landing' => 'landing#index'
  match 'landing/submit' => 'landing#submit'
  match 'landing_new'=>'landing#landing_new'
  #New Sign UP
  #~ match '/home', :to => redirect('/')
  #~ match '/search', :to => redirect('/')
  match '/home/search', :to => redirect('/')
  match 'invite_provider'=>'landing#invite_provider'
  match 'blog_content' => 'landing#blog_content'
  match 'landing_feature' => 'landing#landing_feature'
  
  match 'invite_provider_submit' =>'landing#invite_provider_submit'
  #csv import
  match 'csv_import' => 'contact_users#csv_import'
  match 'file_import' => 'contact_users#file_import'  
  match 'search_famtivity_members' => 'contact_users#search_famtivity_members'  
  match 'check_repeated_users' => 'contact_users#check_repeated_users' 
  match 'check_same_users' => 'contact_users#check_same_users' 
  match 'send_friend_request' => 'contact_users#send_friend_request'
  match 'contact_type_filter' => 'contact_users#contact_type_filter'
  match 'accept_request' => 'contact_users#accept_request'
  match 'contact_send_message' => 'contact_users#contact_send_message'  
  match 'search_contact_user' => 'contact_users#search_contact_user'  
 
  #match 'parent_privacy_policy' => 'landing#parent_privacy_policy'
  #match 'provider_privacy_policy' => 'landing#provider_privacy_policy'
  #match 'parent_terms_of_service' => 'landing#parent_terms_of_service'
  #match 'provider_terms_of_service' => 'landing#provider_terms_of_service'
 
  match 'become_provider' => 'landing#become_provider'
  match 'parent_settings' => 'user_profiles#parent_settings'
  match 'parent_settings_new' => 'user_profiles#parent_settings_new'
  match 'add_mobile_send_code' => 'messages#add_mobile_send_code'
  match 'mobile_code_verification' => 'messages#mobile_code_verification'
  match 'remove_sms_num' => 'messages#remove_sms_num'

  #~ match 'invite_friend' => 'landing#invite_friend'
  #~ match 'invite_contact_success' => 'landing#invite_contact_success'
  match 'invite_friend' => 'contact_users#invite_friend'
  match 'invite_friend_famtivity' => 'contact_users#invite_friend_famtivity'
  #added routing for analytics and seo start
  match 'invite-a-friend(/:check_invite)' => 'contact_users#invite_friend_famtivity'
  match 'find-famtivity-members(/:check_invite)' => 'contact_users#invite_friend_famtivity'
  match 'import-invite-friends(/:check_invite)' => 'contact_users#invite_friend_famtivity'
  #end of analytic and seo routing
  match 'contact_users' => 'contact_users#contact_index'
  match 'csv_contacts' => 'contact_users#csv_contacts'
  match 'invite_contact_success' => 'contact_users#invite_contact_success'
  match 'send_message_success' => 'contact_users#send_message_success'
  match 'newsletter_accept' => 'contact_users#newsletter_accept'
  match 'contact_create_message' => 'contact_users#contact_create_message'
 
  
  #notification for setting page 
  match 'notification_details'=>'user_profiles#notification_details'
  match 'notification_details_provider'=>'user_profiles#notification_details_provider'
  match "edit_payment_detail" =>'user_transactions#edit_payment_detail'
  match 'parent_settings_old' => 'user_profiles#parent_settings_old'
  #match 'update_userpassword' => 'user_profiles#update_userpassword'
  match 'blocked_user' => 'user_profiles#blocked_user'
  match 'create_setting' => 'user_profiles#create_setting'
  #match 'create_parent_settings' => 'user_profiles#create_parent_settings'
  #match 'create_provider_settings' => 'user_profiles#create_provider_settings'
  match 'provider_settings' => 'user_profiles#provider_settings'
  match 'provider_settings_new' => 'user_profiles#provider_settings_new'
  match 'service_discover_more' => 'landing#service_discover_more'
  match 'service_purchase_more' => 'landing#service_purchase_more'
  match 'purchase_payment_more' => 'landing#purchase_payment_more'
  match 'activity_create_bid'=>'sponsor_ships#activity_create_bid'
  match 'test_repeat'=>'activities#test_repeat'
  match 'create_bid'=>'sponsor_ships#create_bid'
  match 'build_activity_network_popup' => 'activities#build_activity_network_popup'
  match 'message_preview_attachment' => 'activities#message_preview_attachment'  #suppot page for all the users
  match 'support' => 'supports#support'
  match 'feedback' => 'supports#feedback'
  match 'support_create' =>'supports#support_create'
  match 'feedback_create' =>'supports#feedback_create'
  
  #SEO URL restructure
  match 'about-us' =>'static#about_us'
  match '/about_us', :to => redirect('/about-us')  
  match 'contact-us' =>'static#contact_us'
  match '/contact_us', :to => redirect('/contact-us')  
  match 'privacy-policy' => 'static#privacy_policy'
  match '/privacy_policy', :to=>redirect('/privacy-policy') 
  match 'how-it-works' => 'landing#how_it_works'
  match '/how_it_works', :to=>redirect('/how-it-works')
  match '/terms_of_service', :to => redirect('/terms-of-service')
  match 'terms-of-service' => 'static#terms_of_service'
  match '/parent_terms_of_service', :to => redirect('/parent-terms-of-service')
  match 'parent-terms-of-service' => 'static#parent_terms_of_service'
  match 'provider-terms-of-service' => 'static#provider_terms_of_service'
  match 'parent-privacy-policy' => 'static#parent_privacy_policy'
  match 'provider-privacy-policy' => 'static#provider_privacy_policy'
  match 'frequently-asked-questions' =>'static#faq'
  match '/faq', :to => redirect('/frequently-asked-questions')
  match 'famtivity-survey'=>'supports#survey_monkey'
  match '/survey_monkey', :to => redirect('/famtivity-survey')
  match 'newsletter' =>'landing#newsletter' 
  
  get "supports/support_form_thank"
  get "supports/feedback_thank"
  
  

  #activity save a copy
  # match 'activity_save_copy' => 'activities#activity_save_copy'
  #login  and logout page
  #match 'login' => 'login#index'
  match 'login_submit' => 'login#submit'
  match 'logout' => 'logout#index'
  match 'login' => 'login#new_login'
  #match 'new_login' => 'login#new_login'
  
  #forgot password
  match 'forgot_password' => 'login#forgot_password'

  #registration page
  
  match 'provider_register' => 'users#new_provider_register'   
  #match 'provider_register' => 'users#provider_register'   
  #match 'parent_register' => 'users#parent_register'
  match 'parent_register' => 'users#new_parent_register'
  match 'pricing-plans/:price' => 'users#parent_register'
  match 'partner_register' => 'users#parent_register'
  
  match 'user_activate' => 'users#user_activate'
  match 'user' => 'users#user_register'
  match 'provider_test' => 'users#provider_test'
  match 'user_submit' => 'users#user_submit'
  #match 'provider_submit' => 'users#provider_submit'
  match 'provider_market'=>'users#provider_market'
  match 'provider_sponsor'=>'users#provider_sponsor'
  match 'sell_through_provider'=>'users#provider_sell'
  match 'provider_sell_submit'=>'users#provider_sell_submit' 
  match 'provider_sponsor_submit'=>'users#provider_sponsor_submit'

  match 'internal_provider'=>'users#internal_provider'
  match 'internal_provider_submit'=>'users#internal_provider_submit'
  #user update files
  match 'parent_profile' => 'user_profiles#parent_profile'
  match 'parent/parent_profile' => 'user_profiles#parent_profile'
  match 'parent_edit_profile' => 'user_profiles#parent_edit_profile'
  match 'parent_update_profile' => 'user_profiles#parent_update_profile'
  #~ match 'provider_edit_profile' => 'user_profiles#provider_edit_profile'  
  #~ match 'provider_update_profile' => 'user_profiles#provider_update_profile'
  #~ match 'provider_profile' => 'user_profiles#provider_profile'
  match 'provider_edit_profile' => 'provider_settings#provider_edit_profile'  
  match 'provider_update_profile' => 'provider_settings#provider_update_profile'
  match 'provider_profile' => 'provider_settings#provider_profile'
  match 'participant_destroy' => 'user_profiles#participant_destroy'
  match 'agecolor_destroy' => 'user_profiles#agecolor_destroy'
  match 'activity_save_copy' => 'provider_settings#activity_save_copy'
  #match 'downsell'=>'user_profiles#downsell'





  #parent index page
  match 'activity_parent' =>'activities#activity_parent'
  match 'schedule_price_detail'=>'activities#schedule_price_detail'
  match 'advanced_search'=>'activities#advanced_search'
  match 'provider_advance_search'=>'activities#provider_advance_search'
  match 'advance_search_new'=>'activities#advance_search_new'
  #~ match 'event_index' =>'activities#event_index'
  match 'event_index' =>'landing#landing_new'
  match 'register' =>'landing#register'
  #match 'change_password' => 'user_profiles#change_password'
  match "update_password" => "activities#update_password"
  match 'event/activity_update'=>'activities#activity_update'
  match 'tickets/ticket_update'=>'tickets#ticket_update'
  match 'search_index'=>'activities#search_index'
  #~ match 'search'=>'activities#search'
  match 'provider_basic_search'=>'activities#provider_basic_search'
  #~ match 'search_event_index'=>'activities#search_event_index'
  #match 'search'=>'search#search'
  #seo url changes
  match 'search/:type/:user_id/:pro_name'=>'search#search'
  match 'search_by_keyword'=>'activities#search_by_keyword'
  match 'basic_search_count'=>'activities#basic_search_count'
  match 'landing_search'=>'activities#landing_search'
  match 'advance_search'=>'activities#advance_search'
  #~ match 'event/event_index_update'=>'activities#event_index_update'
  match 'event/event_index_update'=>'landing#landing_new'
  match 'activity_create' =>'activities#activity_create'
  match 'provider_create' => 'activities#provider_create'
  match 'check_exist' =>'create_new_activity#check_exist'
  match 'create_new_activity' => 'activities#activity_create_index_new'
  
  # new create activity File
  match 'create_new_activity_new' => 'activities#activity_create_index_new'
  
  match "event_activity_update"=>"activity_detail#event_activity_update"
  match "parent_activity_update"=>"activity_detail#parent_activity_update"
  match "provider_activites"=>"activities#provider_activites"
  match "invite_provider" =>"activities#invite_provider"
  

  #sponsor_ships_controller page
  match "billing_sponsorship" =>"sponsor_ships#billing_sponsorship"
  match "bid_setup" =>"sponsor_ships#bid_setup"
  match "edit_bid" =>"sponsor_ships#edit_bid"

  
  match 'act_date' =>'activities#act_date'
  match 'save_favorites'=>'activities#save_favorites'
  match 'update_active_status'=>'activities#update_active_status'



  match "activity_parent_schedule"=>"activity_schedules#activity_parent_schedule"
  match "activity_provider_schedule"=>"activity_schedules#activity_provider_schedule"
  match "schedule_check"=>"activity_schedules#schedule_check"
  match "schedule_contact"=>"activity_schedules#schedule_contact"
  
  #tickets
  match "accept_tickets" =>"tickets#accept_tickets"
  match "participant_detail" =>"tickets#participant_detail"
  match "ticket_edit" =>"tickets#ticket_edit"
  match "ticket_view" =>"tickets#ticket_view"
  match "check_contact_exist" => "contact_users#check_contact_exist"
  match "check_contact_invite" => "contact_users#check_contact_invite"
  #newadd
  #match "ticket_newedit" =>"tickets#ticket_newedit"
  #match "ticket_show" =>"tickets#ticket_show"
  # match '/ticket_newedit', :controller => 'tikets', :action => 'ticket_newedit', :as => :ticket_newedit
 
  #My account page submenu
  match "provider_plan" =>"user_profiles#provider_plan"
  match "provider_transaction" =>"user_transactions#provider_transaction"
  match "transaction_detail" =>"user_transactions#transaction_detail"
  #~ match "payment_setup" =>"user_transactions#payment_setup"
  match "payment_setup" =>"provider_settings#payment_setup"
  match "pop_provider_payment_details" =>"user_transactions#pop_provider_payment_details"
  #~ match "provider_policies" =>"policies#provider_policies" 
  match "provider_policies" =>"provider_settings#provider_policies" 
  
  #import contacts
  #match '/contact_users' => 'contact_users#import'
  match '/contact_users/new_import' => 'contact_users#new_import'
  match '/yahoo_contact_success' => 'contact_users#yahoo_contact_success' 
  match '/add_contact_success' => 'contact_users#add_contact_success' 
  match '/gmail_contact_success' => 'contact_users#gmail_contact_success' 
  match '/facebook_contact_success' => 'contact_users#facebook_contact_success' 
  match '/multi_email' => 'contact_users#multi_email' 
  match '/contact_invite' => 'contact_users#contact_invite' 
  match '/send_message' => 'contact_users#send_message' 
  match '/invite_mail' => 'contact_users#invite_mail' 
  match 'facebook_invite' => 'contact_users#facebook_invite' 
  match 'invite_success' => 'contact_users#invite_success'
  match 'contact_activate' => 'contact_users#contact_activate' 
  match '/fam_member_activate' => 'contact_users#fam_member_activate'
  match 'gmail_import' => 'contact_users#gmail_import'
  match 'invite_facebook_import' => 'contact_users#invite_facebook_import' 
  match 'edit_success' => 'user_profiles#edit_success' 
  #~ match 'policy_update' => 'policies#policy_update' 
  match 'policy_update' => 'provider_settings#policy_update' 
  post "contact_users/policy_file_delete"
  #match 'ptype_create' => 'policies#ptype_create'

  #Routes for upload,download and destroy of policy_files in policy
  #~ match 'upload_policy' => 'policies#upload_policy' 
  match 'upload_policy' => 'provider_settings#upload_policy' 
  #~ match 'download_policy' => 'policies#download_policy' 
  match 'download_policy' => 'provider_settings#download_policy' 
  match 'policy_file_delete' => 'provider_settings#policy_file_delete'  
  
  #Routes for multiple/single download in checkout page
  match 'file_download_checkout' => 'activities#file_download_checkout'  
  match 'multi_download' => 'activities#multi_download'  

  #match '/create' => 'authentications#create' onclick
  match '/auth/facebook/callback' => 'authentications#create'
  #match 'auth/facebook/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  #match 'signout', to: 'sessions#destroy', as: 'signout'`

  #curator use
  match "provider_list" => "provider_list#index"
  match "proviter_submit" => "provider_list#providersubmit"
  
  #discount code check
  match 'checkDiscountCode' => 'checkout#checkDiscountCode'  
  
  #form builder
  match "add_form_builder"=>"forms#add_form_builder"
  match "save_form_field" => "forms#save_form_field"
  match "edit_field_option" => "forms#edit_field_option"
  match "delete_question" => "forms#delete_question"
  match "save_form_question" => "forms#save_form_question"
  match "form_delete" => "forms#form_delete"
  match "form_preview" => "forms#form_preview"
  match "edit_form_builder" => "forms#edit_form_builder"
  match "edit_form_question" => "forms#edit_form_question"
  match "formbuilder_delete" => "forms#formbuilder_delete"
  match "activity_form_assign" => "forms#activity_form_assign"
  #parent fill the required form in activity details page
  match "parent_required_form" => "forms#parent_required_form"
  match "required_form_validate" => "forms#required_form_validate"
  match "required_form_submit" => "forms#required_form_submit"
  match "required_form_update" => "forms#required_form_update"
  match "preview_parent_required_form" => "forms#preview_parent_required_form"
  #network page provider to see the filled form details
  
  


  #user plan transaction Report
  #match "plan_report" => "user_transactions#plan_report"
  #match "transaction" =>"user_transactions#transaction"
  match "plan_report" => "provider_settings#plan_report"
  match "transaction" =>"provider_settings#transaction"


  match "provider_plan_report" => "admin#provider_plan_report"
  match "admin/providercard_listview" => "admin#providercard_listview"
  match "admin/email_metrics" => "admin#email_metrics"
  match "admin/user_reports"=>"admin#user_reports"
  match "admin/general_reports"=>"admin#general_reports"
  match "admin/category_reports"=>"admin#category_reports"
  match "admin/email_metrics_report" => "admin#email_metrics_report"
  match "admin/metric_report_generation" => "admin#metric_report_generation"
  match "admin/metric_process" => "admin#metric_process"
  match "admin/sort_process" => "admin#sort_process"
  #api for activity count based on user
  match "activity_count_newsletter" => "activities#activity_count_newsletter"
  
  #get "contact_users/contact_invite"
  
  match "partner_link"=>"generate_partner_unique_url#generatePartnerUniqueUrl"
  
  resources :featured_audit_logs

  resources :activity_schedules

  resources :activity_repeats

  resources :activity_categories

  resources :activity_subcategories

  resources :activities

  resources :activity_shareds

  resources :activity_favorites

  resources :default_filters

  resources :activity_comments

  resources :activity_rows

  resources :activity_attend_details

  resources :activity_ratings

  resources :contact_users do
    collection do
      post :csv_import
      get :contact_import
      get :contact_store
      get :facebook_import
      get :new_import
      #get :gmail_import
      get :site_contacts 
      get :multi_email
      get :facebook_invite
      #post :add_contact_success
    end
  end

  resources :contact_groups do
    collection do
      post :assign_to_groups
    end
    member do
      get :filter_contacts_by_groups
      get :delete_group
    end
  end
  resources :payment_details
  
  resources :sponsor_ships
 
  #newadd
  resources :tickets  do
    collection do
      get :ticket_newedit
    end
  end
  resources :authentications do 
    collection do

      get :create
      get :facebook_import
      #get :import
    end
  end
  match 'home/:network'=>'home#index'
  resources :home
  match 'home_articles'=>'home#home_articles'
  match 'home_fam_network'=>'home#home_fam_network'
  match 'featured_activity_detail'=>'home#featured_activity_detail'
  match "find_location_by_ip" => "details_page#find_location_by_ip"

  

match '/provider_not_found' => 'details_page#provider_error_page'

  #~ resources :supports

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  match '/provider_not_found' => 'details_page#provider_error_page'
  
  match '/special-activities' => redirect("/hot-deals-activities") 
  match '/discount-activities' =>redirect("/hot-deals-activities")
  match '/:search_type-activities'=>'quick_links#quick_links'
  #New Activity Detail page
  match '/:city/:categ' => 'details_page#index' #new SEO url  changes
  match '/:city/:categ/:sub_categ/:busi_name/:activity_name' => 'details_page#index',:constraints => lambda{|req| req.original_url().match(/missing.png/).nil?} #new SEO url  changes

  #SEO new url changes for location and category page
  match '/locations'=>'quick_links#browse_by_location'
  match 'categories'=>'quick_links#browse_category'
  #match '/:city-ca/:categ'=>'quick_links#browse_category'
  match '/:city/:categ/:sub_categ'=>'details_page#index'
  #match '/:zip_value_name' => 'search#search'

  #New url seo redirects
  match '/locations/:zip_value_name'=> redirect {|params,req| "/#{URI.escape(params[:zip_value_name])}"}
  match 'category/:categ' => redirect {|params,req| "/#{URI.escape(params[:categ])}"}
  match '/category' => redirect("/categories")
  
 
  

  match "category_list" => "static#category_list"
  
  #Old Activity Detail Page
  #match '/:city-ca/:categ' => 'landing#follow_cities' #new SEO url  changes
  #match '/:city-ca/:categ/:sub_categ' => 'landing#follow_cities' #new SEO url  changes
  #match '/:city-ca/:categ/:sub_categ/:busi_name' => 'landing#follow_cities' #new SEO url  changes
  #match '/:city-ca/:categ/:sub_categ/:busi_name/:activity_name' => 'landing#follow_cities' #new SEO url 
  #SEO old url for location and category page
  #match '/locations'=>'quick_links#browse_by_location'
  #match '/locations/:zip_value_name'=>'search#search'
  #match 'category'=>'quick_links#browse_category'
  #match 'category/:categ'=>'quick_links#browse_category'
  #match 'category/:categ/:sub_categ'=>'quick_links#browse_category'
  match 'city/:data(/:city(/:profile_id))' => 'landing#follow_provider_card'
  match 'city/:data(/:city(/:profile_id((/:user)/:det_user_id)))' => 'landing#follow_provider_card'
  #~ seo redirect fixes for browse location
  match "/cities/:data" => redirect("/")
  match "/cities/:data/:city" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca"}
  match "/cities/:data/:city/:categ" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca/#{URI.escape(params[:categ])}"}
  match "/cities/:data/:city/:categ/:sub_categ" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca/#{URI.escape(params[:categ])}/#{URI.escape(params[:sub_categ])}"}
  match "/cities/:data/:city/:categ/:sub_categ/:busi_name" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca/#{URI.escape(params[:categ])}/#{URI.escape(params[:sub_categ])}/#{URI.escape(params[:busi_name])}"}
  match "/cities/:data/:city/:categ/:sub_categ/:busi_name/:activity_name" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca/#{URI.escape(params[:categ])}/#{URI.escape(params[:sub_categ])}/#{URI.escape(params[:busi_name])}/#{URI.escape(params[:activity_name])}"}
  match "/city/:data/:city" => redirect("/")
  match "/search_event_index" => redirect("/search")
  match "activities/:mode/:city/:categ" => redirect {|params,req| "/#{URI.escape(params[:city])}-ca/#{URI.escape(params[:categ])}"}
  match 'activities(/:city-ca(/:det))' =>'activity_detail#activities'
  #match 'activities(/:mode(/:city(/:category(/:sub_category(/:det)))))' =>'activity_detail#activities'
  
  ###########################
  #match '/:city-ca' => 'landing#follow_cities' #old SEO url  changes
  match '/:zip_value_name' => 'search#search_new_search'
  # See how all your routes lay out with "rake routes"
  
  root :to => 'home#index'
  
  ###########################3
  match ':controller(/:action(/:id))(.:format)'

  #~ match '*a',to: redirect('/')
  match '*a', :to => 'errors#routing'
 
end
