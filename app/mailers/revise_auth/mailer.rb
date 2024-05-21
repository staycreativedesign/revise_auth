class ReviseAuth::Mailer < ApplicationMailer
  def confirm_email
    @account = params[:account]
    @token = params[:token]

    mail to: @account.unconfirmed_email
  end

  def password_reset
    @account = params[:account]
    @token = params[:token]

    mail to: @account.email
  end
end
