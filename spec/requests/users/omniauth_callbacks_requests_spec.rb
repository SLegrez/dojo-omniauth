require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe "#facebook" do
    let(:user) { create(:user, facebook_uid: "1234") }

    context "when calling the authorize route" do
      subject { post user_facebook_omniauth_authorize_path }

      it "should redirect to Facebook" do
        subject
        expect(response.status).to eq(302)
      end
    end

    context "when calling the callback route" do
      subject { post user_facebook_omniauth_callback_path }

      mock_omniauth

      context "given the service succeeds" do
        before do
          expect(Users::OmniauthTransaction).to(receive(:call).with({
            provider: "facebook",
            auth: {
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
          }).and_return(Dry::Monads::Success.new(user: user)))
        end

        it "signs me in" do
          subject
          expect(controller.current_user).to eq(user)
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end

      context "given the service fails because the facebook auth failed" do
        before do
          expect(Users::OmniauthTransaction).to receive(:call).exactly(1).times do
            Dry::Monads::Failure.new(error: "error")
          end
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end
    end
  end

  describe "#google" do
    let(:user) { create(:user, google_uid: "1234") }

    context "when calling the authorize route" do
      subject { post user_google_oauth2_omniauth_authorize_path }

      it "should redirect to Google" do
        subject
        expect(response.status).to eq(302)
      end
    end

    context "when calling the callback route" do
      subject { post user_google_oauth2_omniauth_callback_path }

      mock_omniauth

      context "given the service succeeds" do
        before do
          expect(Users::OmniauthTransaction).to(receive(:call).with({
            provider: "google",
            auth: {
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
          }).and_return(Dry::Monads::Success.new(user: user)))
        end

        it "signs me in" do
          subject
          expect(controller.current_user).to eq(user)
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end

      context "given the service fails because the facebook auth failed" do
        before do
          expect(Users::OmniauthTransaction).to receive(:call).exactly(1).times do
            Dry::Monads::Failure.new(error: "error")
          end
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end
    end
  end

  describe "#linkedin" do
    let(:user) { create(:user, linkedin_uid: "1234") }

    context "when calling the authorize route" do
      subject { post user_linkedin_omniauth_authorize_path }

      it "should redirect to Linkedin" do
        subject
        expect(response.status).to eq(302)
      end
    end

    context "when calling the callback route" do
      subject { post user_linkedin_omniauth_callback_path }

      mock_omniauth

      context "given the service succeeds" do
        before do
          expect(Users::OmniauthTransaction).to(receive(:call).with({
            provider: "linkedin",
            auth: {
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
          }).and_return(Dry::Monads::Success.new(user: user)))
        end

        it "signs me in" do
          subject
          expect(controller.current_user).to eq(user)
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end

      context "given the service fails because the facebook auth failed" do
        before do
          expect(Users::OmniauthTransaction).to receive(:call).exactly(1).times do
            Dry::Monads::Failure.new(error: "error")
          end
        end

        it "redirects to root_path" do
          expect(subject).to redirect_to(root_path)
        end
      end
    end
  end
end
