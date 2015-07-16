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

	context "PATCH update" do

		let(:user){ create(:user) }
		before do
			user.generate_password_reset_token! 
		end

		it "sets the user password_reset_token to empty" do
			patch :update, id: user.password_reset_token, user: { password: "alvinjing", 
				password_confirmation: "alvinjing" }
			user.reload
			expect(flash[:notice]).to match(/Password updated/i)
			expect(user.password_reset_token).to be_blank
		end

		it "logs the user in by setting the user session id" do 
			patch :update, id: user.password_reset_token, user: { password: "alvinjing", 
				password_confirmation: "alvinjing" }
			user.reload
		end

		it "flash password and password_confirmation not the same" do 

		end
	end
end
