class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters  , if: :devise_controller?
  #before_action :log_action 

  def respond_modal_with(*args, &blk)
    Rails.logger.info "respond_modal_with args:" + show_args(*args).to_s 
    Rails.logger.info "respond_modal_with blk:" + blk.inspect
    options = args.extract_options!
    options[:responder] = ModalResponder
    Rails.logger.info "respond_modal_with options:" + options.to_s
    respond_with *args, options, &blk
    Rails.logger.info "respond_modal_with Done"
  end

  protected
  def configure_permitted_parameters
   #devise_parameter_sanitizer.for(:sign_up) << :username :birthdate
#   devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :birthdate, :email, :password, :password_confirmation])
#   devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :birthdate, :email, :password, :password_confirmation])
#   devise_parameter_sanitizer.permit(:account_update, keys: [:username, :birthdate, :email, :password, :password_confirmation, :current_password])

   devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :birthdate, :email, :password, :password_confirmation) } 
   devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:username, :email,:password,:remember_me) }
   devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :birthdate,:email, :password, :password_confirmation, :current_password)}

  end
  def log_action
    Rails.logger.info "in: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
    Rails.logger.info "params are: #{params.inspect}"
  end
  def show_args(*args)
    args.each do |arg_item|
      Rails.logger.info  arg_item.inspect
      Rails.logger.info  arg_item.class.inspect
    end
  end

end
