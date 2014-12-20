require "rails_helper"


describe Product do
      context "validation for model" do
	it { should validate_presence_of :description }
	it { should validate_presence_of :title }
	it { should validate_presence_of :price }
	end
       it "has a valid factory" do
	       FactoryGirl.create(:product).should be_valid
       end
       
        it "is invalid without a description" do
		FactoryGirl.build(:product, description: nil).should_not be_valid 
	end 
	
	it "is invalid without a title" do
		FactoryGirl.build(:product, title: nil).should_not be_valid 
	end 
	
	it "is invalid without a price" do
		FactoryGirl.build(:product, price: nil).should_not be_valid 
	end 
	
  end
  