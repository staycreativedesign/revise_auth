class ReviseAuth::SessionsController < ReviseAuthController
  def new; end

  def create
    if (account = Account.authenticate_by(email: params[:email], password: params[:password]))
      login(account)
      redirect_to resolve_after_login_path
    else
      flash[:alert] = t('.invalid_email_or_password')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def resolve_after_login_path
    try(:after_login_path) || return_to_location || root_path
  end

  def return_to_location
    session.delete(:account_return_to)
  end
end
