# frozen_string_literal: true

# General class for mailers
class ApplicationMailer < ActionMailer::Base
  require 'digest/sha2'
  include Roadie::Rails::Automatic
  default(from: 'Sektionsmöte <no-reply@ftek.se>')
  layout('email')
  helper(EmailHelper)

  protected

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@ftek.se>"
  end
end
