require 'spec_helper'

describe PasswordResetsController do
	it "renders the new template" do
		get :new
		expect(response).to render_template('new')
	end

	context "POST Create" do
		let!(:user){ create(:user) }

		it "finds the user" do
			expect(User).to receive(:find_by).with(email: user.email).and_return(user)
			post :create, email: user.email
		end

		it "generates new password_reset_token for the user" do
			expect(User).to receive(:find_by).with(email: user.email).and_return(user)
			expect{ post :create, email: user.email }.to change{user.password_reset_token}
		end
	end
end
