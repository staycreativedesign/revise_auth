module ReviseAuth
  module Authentication
    # Provides methods for controllers and views for authentication
    #
    extend ActiveSupport::Concern

    included do
      helper_method :account_signed_in?
      helper_method :current_account
    end

    # Returns a boolean whether the account is signed in or not
    def account_signed_in?
      !!current_account
    end

    # Authenticates the account if not already authenticated
    # Returns a Account or nil
    def current_account
      Current.account ||= authenticate_account
    end

    # Authenticates a account or redirects to the login page
    def authenticate_account!
      redirect_to_login_with_stashed_location unless account_signed_in?
    end

    # Authenticates the current account
    # - from session cookie
    # - (future) from Authorization header
    def authenticate_account
      Current.account = authenticated_account_from_session
    end

    # Returns a account from session cookie
    def authenticated_account_from_session
      account_id = session[:account_id]
      return unless account_id

      Account.find_by(id: account_id)
    end

    # Logs in the account
    # - Reset the session to prevent session fixation
    #   See: https://guides.rubyonrails.org/security.html#session-fixation-countermeasures
    # - Set Current.account for the current request
    # - Save a session cookie so the next request is authenticated
    def login(account)
      account_return_to = session[:account_return_to]
      reset_session
      Current.account = account
      session[:account_id] = account.id
      session[:account_return_to] = account_return_to
    end

    def logout
      reset_session
      Current.account = nil
    end

    def stash_return_to_location(path)
      session[:account_return_to] = path
    end

    def redirect_to_login_with_stashed_location
      stash_return_to_location(request.fullpath) if request.get?
      redirect_to login_path, alert: I18n.t('revise_auth.sign_up_or_login')
    end

    # Return true if it's a revise_auth_controller. false to all controllers unless
    # the controllers defined inside revise_auth. Useful if you want to apply a before
    # filter to all controllers, except the ones in revise_auth:
    #
    #   before_action :authenticate_account!, unless: :revise_auth_controller?
    def revise_auth_controller?
      is_a?(::ReviseAuthController)
    end
  end
end
