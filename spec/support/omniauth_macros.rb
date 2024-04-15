module OmniauthMacros
  def mock_omniauth
    before(:each) do
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:default] = {
        "uid" => "1234",
        "info" => {
          "first_name" => "Example",
          "last_name" => "User",
          "email" => "random@capsens.eu"
        },
        "credentials" => {
          "token" => "token",
          "secret" => "secret"
        }
      }
    end
  end
end
