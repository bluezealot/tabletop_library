class SessionsController < ApplicationController
    
    def new
        
    end
    
    def create
        user = User.find_by_user_name(params[:session][:user_name])
        if user && user.authenticate(params[:session][:password])
            sign_in user
            redirect_to root_url
        else
            redirect_to signin_path, notice: 'Invalid user/pass combo.'
        end
    end
    
    def destroy
        sign_out
        redirect_to root_url
    end
    
end
