require "test_helper"

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
    changes_applied
  end

  def truthly?
    true
  end

  def falsy?
    false
  end
end

class ChangesValidatorTest < ActiveSupport::TestCase
  def setup
    User.clear_validators!
    @user = User.new
  end

  test "should work" do
    assert @user.valid?
  end

  test "should support state change according to changes table" do
    User.validates :state, changes: { nil => [:pending, :approved] }
    @user.state = "pending"
    assert @user.valid?
    @user.state = "approved"
    assert @user.valid?
  end

  test "should return record invalid if changed to wrong state" do
    User.validates :state, changes: { nil => [:pending, :approved] }
    @user.state = "voided"
    refute @user.valid?
    refute_empty @user.errors[:state]
    assert_equal "can't be changed to voided", @user.errors[:state].first
  end

  test "should raise exception when model doesn't support dirty" do
    klass = Class.new do
      include ActiveModel::Validations
      attr_accessor :state
      validates :state, changes: { nil => :pending }
    end

    assert_raises(ChangesValidator::ConfigurationError) do
      klass.new.valid?
    end
  end

  test "should be able to use custom message" do
    User.validates :state, changes: { with: { nil => [:pending, :approved] }, message: "cannot be changed like this" }
    @user.state = 'declined'
    refute @user.valid?
    refute_empty @user.errors[:state]
    assert_equal "cannot be changed like this", @user.errors[:state].first
  end

  test "should be able to use old_value interpolation in custom message" do
    User.validates :state, changes: { with: { nil => :pending, :pending => [:approved] }, message: "cannot be changed from %{old_value} to %{value}" }
    @user.state = 'pending'
    @user.save!
    @user.state = 'declined'
    refute @user.valid?
    refute_empty @user.errors[:state]
    assert_equal "cannot be changed from pending to declined", @user.errors[:state].first
  end

  test "should be able to use allow_nil option" do
    User.validates :state, changes: { with: { nil => :pending, :pending => [:approved] } }, allow_nil: true
    @user.state = 'pending'
    @user.save!
    @user.state = nil
    assert @user.valid?
  end

  test "should be able to use allow_blank option" do
    User.validates :state, changes: { with: { nil => :pending, :pending => [:approved] } }, allow_blank: true
    @user.state = 'pending'
    @user.save!
    @user.state = ' '
    assert @user.valid?
  end

  test "should be able to use if option" do
    User.validates :state, changes: { with: { nil => :pending, :pending => [:approved] } }, if: :falsy?
    @user.state = 'approved'
    assert @user.valid?
  end

  test "should be able to use unless option" do
    User.validates :state, changes: { with: { nil => :pending, :pending => [:approved] } }, unless: :truthly?
    @user.state = 'approved'
    assert @user.valid?
  end
end

