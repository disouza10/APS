class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  def flash_removed(object)
    flash[:notice] = "#{object.class.model_name.human} foi excluído com sucesso."
  end

  def flash_updated(object)
    flash[:notice] = "#{object.class.model_name.human} foi atualizado com sucesso."
  end

  def flash_created(object)
    flash[:notice] = "#{object.class.model_name.human} foi criado com sucesso."
  end

  def flash_error
    flash[:error] = 'Houve um erro ao processar a requisição.'
  end
end
