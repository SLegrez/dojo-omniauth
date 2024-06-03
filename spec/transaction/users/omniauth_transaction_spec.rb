require "rails_helper"

RSpec.describe Users::OmniauthTransaction, type: :transaction do
  subject { described_class.call(auth: auth, provider: provider) }

  describe ".call" do
    context "given an existing User that already fast-connected" do
      let(:user) { create(:user, facebook_uid: "1234") }
      let(:provider) { "facebook" }
      let(:auth) { OmniAuth::AuthHash.new(info: { email: user.email }, provider: provider, uid: user.facebook_uid) }

      it "returns a Failure" do
        expect(subject).to be_failure
      end
    end

    context "given an existing User" do
      context "that has not already fast-connected" do
        let(:user) { create(:user) }
        let(:provider) { "facebook" }
        let(:auth) { OmniAuth::AuthHash.new(info: { email: user.email }, provider: provider, uid: "1234") }

        it "returns a Success" do
          expect(subject).to be_success
        end

        it "updates the provider uid" do
          subject
          expect(user.reload.facebook_uid).to eq("1234")
        end

        it "updates the User" do
          expect { subject }.to change { user.reload.updated_at }
        end
      end

      context "that has already fast-connected" do
        context "with the same provider" do
          let(:user) { create(:user, facebook_uid: "1234") }
          let(:provider) { "facebook" }
          let(:auth) { OmniAuth::AuthHash.new(info: { email: user.email }, provider: provider, uid: "1234") }

          it "returns a Failure" do
            expect(subject).to be_failure
          end

          it "does not update the User" do
            expect { subject }.to_not change { user.reload.updated_at }
          end
        end

        context "with another provider" do
          let(:user) { create(:user, facebook_uid: "1234") }
          let(:provider) { "google" }
          let(:auth) { OmniAuth::AuthHash.new(info: { email: user.email }, provider: provider, uid: "1234") }

          it "returns a Success" do
            expect(subject).to be_success
          end

          it "updates the other provider uid" do
            subject
            expect(user.reload.google_uid).to eq("1234")
          end

          it "updates the User" do
            expect { subject }.to change { user.reload.updated_at }
          end
        end
      end
    end

    context "given a non existing valid User" do
      let(:user) { build(:user) }
      let(:provider) { "google" }
      let(:auth) { OmniAuth::AuthHash.new(
        info: {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name
        },
        provider: provider,
        uid: user.google_uid
      )}

      it "creates a new User in database" do
        expect { subject }.to change { User.count }.by(1)
      end

      it "returns a Success" do
        expect(subject).to be_success
      end
    end

    context "given a non existing unvalid User" do
      let(:user) { build(:user) }
      let(:provider) { "linkedin" }
      let(:auth) { OmniAuth::AuthHash.new(info: { email: nil }, provider: provider) }

      it "does not create a new User in database" do
        expect(User.count).to eq(0)
      end

      it "returns a Failure" do
        expect(subject).to be_failure
      end
    end
  end
end
