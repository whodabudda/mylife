class ModalResponder < ActionController::Responder
  cattr_accessor :modal_layout
  self.modal_layout = 'modal'

  def render(*args)
    Rails.logger.info "in ModalResponder:render args: "
    show_args(*args)
    Rails.logger.info "in ModalResponder:render request.xhr?: " + request.xhr?.to_s
    options = args.extract_options!
    if request.xhr?
      options.merge! layout: modal_layout
    end
    Rails.logger.info "in ModalResponder:render options: " + options.inspect
    Rails.logger.info "in ModalResponder:render controller: " + controller.to_s
    controller.render *args, options
  end

  def default_render(*args)
    Rails.logger.info "in ModalResponder:default_render args: " + args.inspect
    render(*args)
  end

  def redirect_to(options)
    Rails.logger.info "in ModalResponder:redirect_to options: " + options.inspect
    Rails.logger.info "in ModalResponder:redirect_to request.xhr?: " + request.xhr?.to_s
    if request.xhr?
      head :ok, location: controller.url_for(options)
    else
      controller.redirect_to(options)
    end
  end
  def show_args(*args)
    args.each do |arg_item|
      Rails.logger.info  arg_item.inspect
      Rails.logger.info  arg_item.class.inspect
    end
  end
end