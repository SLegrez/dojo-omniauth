class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    launch_omniauth_transaction(__method__.to_s)
  end

  def google_oauth2
    launch_omniauth_transaction("google")
  end

  def linkedin
    launch_omniauth_transaction(__method__.to_s)
  end

  def github
    launch_omniauth_transaction(__method__.to_s)
  end

  def launch_omniauth_transaction(provider)
    transaction = Users::OmniauthTransaction.call(auth: request.env["omniauth.auth"], provider: provider)

    # Inspiration depuis le Wiki de Devise : https://github.com/heartcombo/devise/wiki/OmniAuth%3A-Overview
    if transaction.success?
      sign_in_and_redirect(transaction.success[:user], event: :authentication)
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      flash[:error] = transaction.failure[:error]
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to(unauthenticated_root_path)
    end
  end

  def failure
    redirect_to(unauthenticated_root_path)
  end
end
