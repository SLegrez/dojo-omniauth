class Users::OmniauthTransaction < ApplicationTransaction
  tee :params
  step :existing_fast_connected_user?
  step :update_existing_user!
  step :find_or_create_user!

  def params(input)
    @auth = input.fetch(:auth)
    @provider = input.fetch(:provider)
  end

  def existing_fast_connected_user?(input)
    # raise
    existing_user = User.from_omniauth(@auth, @provider)

    if existing_user
      Failure(input.merge(existing_user: existing_user))
    else
      Success(input)
    end
  end

  def update_existing_user!(input)
    @user = User.find_by(email: @auth.info.email)
    return Success(input) if !@user.present?

    @user.assign_attributes("#{@provider}_uid": @auth.uid)
    if @user.save
      Success(input)
    else
      Failure(input.merge(error: user.errors.full_messages.join("\n")))
    end
  end

  def find_or_create_user!(input)
    return Success(user: @user) if @user.present?

    user = User.where("#{@provider}_uid": @auth.uid).first_or_create do |new_user|
      new_user.email      = @auth.info.email
      new_user.password   = Devise.friendly_token +
                            ('A'..'Z').to_a.sample +
                            ('a'..'z').to_a.sample +
                            ('0'..'9').to_a.sample +
                            ('!'..'/').to_a.sample
      new_user.first_name = @auth.info.first_name
      new_user.last_name  = @auth.info.last_name
    end

    if user.persisted?
      Success(input.merge(user: user))
    else
      Failure(input.merge(error: user.errors.full_messages.join("\n")))
    end
  end
end
