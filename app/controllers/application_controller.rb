class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	before_action :authenticate_user!

	rescue_from ActiveRecord::RecordNotFound, with: :back_to_root

	protected
	def ensure_admin!
		unless current_user.is_admin
      sign_out current_user
      redirect_to root_path
      return false
    end
	end

	def ensure_vendedor!
		unless current_user.is_admin || current_user.vendedor
      sign_out current_user
      redirect_to root_path
      return false
    end
	end

	def back_to_root
		redirect_to root_path
	end
end
