# spec/factories/products.rb
#~ require 'faker'
FactoryGirl.define do 
	factory :product, class: Product do |f|
	f.title "Rajkumar" 
	f.description "Rspec for products" 
	f.price "150"
	end
end 