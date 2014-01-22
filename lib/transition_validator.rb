require "active_model"

class TransitionValidator < ActiveModel::EachValidator

  def initialize(*)
    super
    normalize_options
  end

  def validate_each(record, attribute, value)
    ensure_supports_dirty(record)
    changes = record.changes[attribute.to_s]
    return unless changes
    transitions = options[:with]
    start = changes.first
    destination = value
    message = options[:message] || :transition

    allowed_transitions = transitions[start]
    if !allowed_transitions || !Array(allowed_transitions).map {|s| s.to_s }.include?(destination.to_s)
      record.errors.add(attribute, message, :value_was => start)
    end
  end

  def ensure_supports_dirty(record)
    unless record.respond_to?(:changes)
      raise ConfigurationError, "TransitionValidator can only be applied to model with dirty support (ActiveModel::Dirty)"
    end
  end

  class ConfigurationError < Exception; end

  def normalize_options
    unless options[:with]
      @options = {:with => options}
    end
  end
end

I18n.load_path << File.expand_path('../../locales/en.yml', __FILE__)
