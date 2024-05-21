class ReviseAuth::PasswordController < ReviseAuthController
  before_action :authenticate_account!

  def update
    if current_account.update(password_params)
      redirect_to profile_path, notice: t('.password_changed')
    else
      flash[:alert] = t('.incorrect_password')
      render 'revise_auth/registrations/edit', status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:account).permit(
      :password,
      :password_confirmation,
      :password_challenge
    ).with_defaults(password_challenge: '')
  end
end
