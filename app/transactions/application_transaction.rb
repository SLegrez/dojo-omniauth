require "dry/transaction"

class ApplicationTransaction
  include Dry::Transaction

  def self.call(*args, &block)
    self.new.call(*args, &block)
  end

  private

  def failure_hash(message, resource)
    {
      message:  message,
      resource: resource
    }
  end

  def error(message, **params)
    # example for translation scope: User::CreateTransaction ==> fr: user: create_transaction:
    {message: t(message, **params)}
  end

  def t(key, **params)
    I18n.t(key, scope: self.class.name.gsub('::', '.').underscore, **params, default: I18n.t(key, **params))
  end

  def cms_configuration
    @_cms_configuration ||= Cms::Configuration.instance
  end
end
