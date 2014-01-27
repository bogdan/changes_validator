# TransitionValidator

TransitionValidator is the most minimalistic state machine implementation focused on validating a state transition rather than define API methods and logic.


## Why TransitionValidator?

The best way to define API and logic in Ruby is using Ruby.
TransitionValidator does only validation that Object can move from one state to another.

## Dependencies

ActiveModel

## Installation

Add this line to your application's Gemfile:

    gem 'transition_validator'

And then execute:

    $ bundle

## Usage


### Basic setup

If the state machine's main goal is to validate transitions than let's implement it as a validation:

``` ruby
class Reward < AR::Base
  validates! :state, :transition => { 
    nil => [:pending], # Initial state is always pending
    :pending => [:approved, :rejected], # Pending can be transitioned to to approved and rejected
    :approved => :paid # Approved can only be transitioned to paid
  }
end
```

Recommended to use with strict validation method: `validates!` as wrong state transition use to be programmer mistake but not user input mistake.
In this case exception will be raise and logged.


### Advanced Options

* `:message` - validation message.  Can have %{value} and %{old\_value} interpolation variables.
  * Default: "Can not be transitioned to %{value}"
  * Example: "Can not be transitioned from %{old\_value} to %{value}"
* `:allow_nil` - don't apply validator if value is nil
* `:allow_blank` - don't apply validator if value is blank
* `:if` - only apply validator if specified method return true
* `:unless` - only apply validator if specified method return false
* `:strict` - if true this validator will always raise  when record is invalid
  * Default:
  



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
