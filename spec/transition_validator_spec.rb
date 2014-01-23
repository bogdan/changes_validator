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

  def save
    @previously_changed = changes
    @changed_attributes.clear
  end


end


describe TransitionValidator do
  before do
    User.clear_validators! 
  end
  let!(:user) { User.new }
  it "should work" do
    user.should be_valid
  end

  it "should support state change according to transitions table" do
    User.validates :state, :transition => {nil => [:pending, :approved]}
    user.state = "pending"
    user.should be_valid
    user.state = "approved"
    user.should be_valid
  end

  it "should return record invalid if transitioned to wrong state" do
    User.validates :state, :transition => {nil => [:pending, :approved]}
    user.state = "voided"
    user.should_not be_valid
    user.errors[:state].should_not be_empty
    user.errors[:state].first.should == "can not be transitioned to voided"
  end


  it "should raise exception when model don't support dirty" do
    klass = Class.new {
      include ActiveModel::Validations
      attr_accessor :state
      validates :state, :transition => {nil => :pending}
    }
    proc  {
      klass.new.valid?
    }.should raise_error(TransitionValidator::ConfigurationError)
  end
  it "should be able to use custom message" do
    User.validates :state, :transition => {:with => {nil => [:pending, :approved]}, :message => "can not be transitioned like this"}
    user.state = 'declined'
    user.should_not be_valid
    user.errors[:state].should_not be_empty
    user.errors[:state].first.should == "can not be transitioned like this"
  end
end
