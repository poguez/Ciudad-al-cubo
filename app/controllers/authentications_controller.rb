class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    #render :text => request.env["omniauth.auth"].to_yaml
#=begin
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Bienvenido a la pagina!."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])  
      flash[:notice] = "Bienvenido de nuevo!."
      redirect_to authentications_url
    else
      #this validation only should works if I only want one authentication per user
      other_user_service = User.find_by_email("")
      if other_user_service == nil
        user = User.new
        user.apply_omniauth(omniauth)
          if user.save
            flash[:notice] = "Bienvenido a la pagina!."
            sign_in_and_redirect(:user, user)
          else
            session[:omniauth] = omniauth.except('extra')
            redirect_to new_user_registration_url
          end
      else
        provider = other_user_service.authentications.first.provider
        message = "Usted ya se autentifico con " + provider + " para este email, si desea ingresar de nuevo haga clic <a href=\"/auth/#{provider}\">aqui</a>"
        flash[:warning] = message.html_safe

        redirect_to new_user_registration_url
      end
    end
#=end
  end


  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
end
