require 'spec_helper'

describe User do

  before(:each) do
    @attr = {:name => "Pippo pippis", :email =>"ppippis@example.com"}
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    user_no_name = User.new(@attr.merge(:name =>""))
    user_no_name.should_not be_valid
  end
  
  it "should require an email" do
    user_no_email = User.new(@attr.merge(:email =>""))
    user_no_email.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "x" * 51
    user_long_name = User.new(@attr.merge(:name => "#{long_name}"))
    user_long_name.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      user_valid_email = User.new(@attr.merge(:email => "#{address}"))
      user_valid_email.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.bar.org first.last@foo.]
    addresses.each do |address|
      user_invalid_email = User.new(@attr.merge(:email => "#{address}"))
      user_invalid_email.should_not be_valid
    end    
  end
  
  it "should reject duplicated email address" do
    User.create!(@attr)
    user_duplicated_email = User.new(@attr.merge(:name => "altro nome"))
    user_duplicated_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case " do
    User.create!(@attr)
    user_identical_email_up_to_case = User.new(@attr.merge(:name => "altro nome", :email => @attr[:email].to_s.upcase))
    user_identical_email_up_to_case.should_not be_valid    
  end
end
