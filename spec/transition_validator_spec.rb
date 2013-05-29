require "spec_helper"

class User
  include ActiveModel::Dirty
  include ActiveModel::Validations

  define_attribute_methods [:state]

  validates :state, :transition => {nil => [:pending, :approved], :pending => [:approved, :voided], :voided => :deleted}

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
  let(:user) { User.new }
  it "should work" do
    user.should be_valid
  end

  it "should support state change according to transitions table" do
    user.state = "pending"
    user.should be_valid
  end

  it "should return record invalid if transitioned to wrong state" do
    user.state = "voided"
    user.should_not be_valid
    user.errors[:state].should_not be_empty
  end
end
