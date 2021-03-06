require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Pippo pippis", 
      :email =>"ppippis@example.com", 
      :password => "abracadabra",
      :password_confirmation => "abracadabra"
    }
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
  
  describe  "password" do
    
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password => "a", :password_confirmation => "b")).
        should_not be_valid      
    end
    
    it "should reject short passwords" do
      short_password = "a" * 5
      hash = @attr.merge(:password => short_password, :password_confirmation => short_password)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long_password = "a" * 41
      hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:password_encrypted)
    end
    
    it "should set the encrypted password attribute" do
      @user.password_encrypted.should_not be_blank
    end
    
    it "should have a salt attribute" do
      @user.should respond_to(:password_salt)
    end
    
    describe "has_password? method" do
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should return false if the passwords don't match" do
        @user.has_password?('invalid_password').should be_false 
      end
    end
    
    describe "authenticate method" do
      it "should exist" do
        User.should respond_to(:authenticate)
      end
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email], "wrongpassword").should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password]).should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end
end
