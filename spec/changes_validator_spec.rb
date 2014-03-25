require "spec_helper"

class User
  include ActiveModel::Dirty
  include ActiveModel::Validations

  define_attribute_methods [:state]

  def state
    @state
  end

  def state=(val)
    state_will_change! unless val == @state
    @state = val
  end

  def save!
    raise 'invalid' unless valid?
    @previously_changed = changes
    @changed_attributes.clear
  end

  def truthly?
    true
  end

  def falsy?
    false
  end


end


describe ChangesValidator do
  before do
    User.clear_validators! 
  end
  let!(:user) { User.new }
  it "should work" do
    user.should be_valid
  end

  it "should support state change according to changess table" do
    User.validates :state, :changes => {nil => [:pending, :approved]}
    user.state = "pending"
    user.should be_valid
    user.state = "approved"
    user.should be_valid
  end

  it "should return record invalid if changesed to wrong state" do
    User.validates :state, :changes => {nil => [:pending, :approved]}
    user.state = "voided"
    user.should_not be_valid
    user.errors[:state].should_not be_empty
    user.errors[:state].first.should == "can't be changesed to voided"
  end


  it "should raise exception when model don't support dirty" do
    klass = Class.new {
      include ActiveModel::Validations
      attr_accessor :state
      validates :state, :changes => {nil => :pending}
    }
    proc  {
      klass.new.valid?
    }.should raise_error(ChangesValidator::ConfigurationError)
  end
  it "should be able to use custom message" do
    User.validates :state, :changes => {:with => {nil => [:pending, :approved]}, :message => "can not be changesed like this"}
    user.state = 'declined'
    user.should_not be_valid
    user.errors[:state].should_not be_empty
    user.errors[:state].first.should == "can not be changesed like this"
  end
  it "should be able to use old_value interpolation in custom message" do
    User.validates :state, :changes => {:with => {nil => :pending, :pending => [:approved]}, :message => "can not be changesed from %{old_value} to %{value}"}
    user.state = 'pending'
    user.save!
    user.state = 'declined'
    user.should_not be_valid
    user.errors[:state].should_not be_empty
    user.errors[:state].first.should == "can not be changesed from pending to declined"
  end
  it "should be able to use allow_nil option" do
    User.validates :state, :changes => {:with => {nil => :pending, :pending => [:approved]}}, :allow_nil => true
    user.state = 'pending'
    user.save!
    user.state = nil
    user.should be_valid
  end
  it "should be able to use allow_blank option" do
    User.validates :state, :changes => {:with => {nil => :pending, :pending => [:approved]}}, :allow_blank => true
    user.state = 'pending'
    user.save!
    user.state = ' '
    user.should be_valid
  end
  it "should be able to use if option" do
    User.validates :state, :changes => {:with => {nil => :pending, :pending => [:approved]}}, :if => :falsy?
    user.state = 'approved'
    user.should be_valid
  end
  it "should be able to use unless option" do
    User.validates :state, :changes => {:with => {nil => :pending, :pending => [:approved]}}, :unless => :truthly?
    user.state = 'approved'
    user.should be_valid
  end
end
