class ReturnsController < ApplicationController
    before_filter :reset_session, :only => [:new]
    
    def new
    end
    
    def create
        params[:a_id].upcase!
        if get_attendee(params[:a_id])
            if atte_has_unclosed_co(params[:a_id]).empty?
                flash[:alert] = 'Attendee has no games checked out!'
                redirect_to returns_new_path
            else
                redirect_to returns_confirm_path(params)
            end
        else
            flash[:alert] = 'Attendee does not exist!'
            redirect_to returns_new_path
        end
    end
    
    def show
        @checkouts = atte_has_unclosed_co(params[:a_id])
        @atte = get_attendee(params[:a_id])
    end
    
    def confirm
        params[:g_id].upcase!
        if return_game(params[:a_id], params[:g_id])
            flash[:notice] = 'Game was successfully RETURNED.'
            redirect_to returns_new_path
        else
            flash[:alert] = 'An error occurred while returning.'
            redirect_to returns_new_path
        end
    end
    
end
