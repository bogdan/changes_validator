require "active_model"

class ChangesValidator < ActiveModel::EachValidator

  def initialize(*)
    super
    normalize_options
  end

  def validate_each(record, attribute, value)
    ensure_supports_dirty(record)
    changes = record.changes[attribute.to_s]
    return unless changes
    changess = options[:with]
    start = changes.first
    destination = value

    allowed_changess = changess[start]
    if !allowed_changess || !Array(allowed_changess).map {|s| s.to_s }.include?(destination.to_s)
      record.errors.add(attribute, :changes, :old_value => start, :message => options[:message])
    end
  end

  def ensure_supports_dirty(record)
    unless record.respond_to?(:changes)
      raise ConfigurationError, "ChangesValidator can only be applied to model with dirty support (ActiveModel::Dirty)"
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
