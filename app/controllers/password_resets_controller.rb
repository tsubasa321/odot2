class PasswordResetsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:email])
		if user
			user.generate_password_reset_token!
			Notifier.password_reset(user).deliver
			flash[:notice] = "Password reset link has been sent to your email"
			redirect_to login_path
		else
			redirect_to new_user_path, notice: "No user found"
		end
	end
end
