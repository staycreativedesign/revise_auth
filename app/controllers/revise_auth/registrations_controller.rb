class ReviseAuth::RegistrationsController < ReviseAuthController
  before_action :authenticate_account!, except: %i[new create]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(sign_up_params)
    if @account.save
      login(@account)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if current_account.update(profile_params)
      redirect_to profile_path, notice: t('.account_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_account.destroy
    logout
    redirect_to root_path, status: :see_other, alert: t('.account_deleted')
  end

  private

  def sign_up_params
    params.require(:account).permit(ReviseAuth.sign_up_params)
  end

  def profile_params
    params.require(:account).permit(ReviseAuth.update_params)
  end
end
