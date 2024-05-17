class ReviseAuth::PasswordResetsController < ReviseAuthController
  before_action :set_account, only: %i[edit update]

  def new
    @account = Account.new
  end

  def create
    account = Account.find_by(email: account_params[:email])
    account&.send_password_reset_instructions

    flash[:notice] = t('.password_reset_sent')
    redirect_to login_path
  end

  def edit; end

  def update
    if @account.update(password_params)
      flash[:notice] = t('revise_auth.password.update.password_changed')
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = Account.find_by_token_for(:password_reset, params[:token])

    return if @account.present?

    flash[:alert] = t('.invalid_password_link')
    redirect_to new_password_reset_path
  end

  def account_params
    params.require(:account).permit(:email)
  end

  def password_params
    params.require(:account).permit(:password, :password_confirmation)
  end
end
