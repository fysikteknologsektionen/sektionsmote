# frozen_string_literal: true

# General class for mailers
class ApplicationMailer < ActionMailer::Base
  require 'digest/sha2'

  default from: 'Sektionsmöte <styret.info@ftek.se>'
  layout 'email'

  protected

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@ftek.se>"
  end
end
