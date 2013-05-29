require "active_model"

class TransitionValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    ensure_supports_dirty(record)
    return unless record.changes[attribute]
    transitions = options
    start = record.changes[attribute.to_s].first
    destination = value
    message = options[:message] || "can not be transitioned from #{start.inspect} to #{destination.inspect}"

    allowed_transitions = transitions[start]
    unless allowed_transitions
      return record.errors.add(attribute, message)
    end
    unless Array(allowed_transitions).map(&:to_sym).include?(destination.to_sym)
      return record.errors.add(attribute, message)
    end
  end

  def ensure_supports_dirty(record)
    unless record.respond_to?(:changes)
      raise ConfigurationError, "TransitionValidator can only be applied to model with dirty support (ActiveModel::Dirty)"
    end
  end

end

