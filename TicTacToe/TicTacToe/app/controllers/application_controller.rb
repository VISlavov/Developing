class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def index
	end

	def home
		home_template_path = Rails.root.join('app', 'assets', 'templates', 'home.html.erb')
		render file: home_template_path, :layout => false
	end

	def leaderboard
		leaderboard_template_path = Rails.root.join('app', 'assets', 'templates', 'leaderboard.html.erb')
		render file: leaderboard_template_path, :layout => false
	end
end
