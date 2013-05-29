require "active_model"

class TransitionValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    ensure_supports_dirty(record)
    changes = record.changes[attribute.to_s]
    return unless changes
    transitions = options
    start = changes.first
    destination = value
    message = options[:message] || :transition

    allowed_transitions = transitions[start]
    unless allowed_transitions
      return record.errors.add(attribute, message)
    end
    unless Array(allowed_transitions).map {|s| s.to_s }.include?(destination.to_s)
      return record.errors.add(attribute, message)
    end
  end

  def ensure_supports_dirty(record)
    unless record.respond_to?(:changes)
      raise ConfigurationError, "TransitionValidator can only be applied to model with dirty support (ActiveModel::Dirty)"
    end
  end

  class ConfigurationError < Exception; end
end

I18n.load_path << File.expand_path('../../locales/en.yml', __FILE__)
