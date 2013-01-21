class ReturnsController < ApplicationController
    
    def new
    end
    
    def create
        params[:a_id].upcase!
        if get_attendee(params[:a_id])
            if atte_has_unclosed_co(params[:a_id]).empty?
                redirect_to returns_new_path, notice: 'Attendee has no games checked out!'
            else
                redirect_to returns_confirm_path(params)
            end
        else
            redirect_to returns_new_path, notice: 'Attendee does not exist!'
        end
    end
    
    def show
        @checkouts = atte_has_unclosed_co(params[:a_id])
        @atte = get_attendee(@checkouts.first.attendee_id)
    end
    
    def confirm
        params[:g_id].upcase!
        if return_game(params[:a_id], params[:g_id])
            redirect_to returns_new_path, notice: 'Return complete.'
        else
            redirect_to returns_new_path, notice: 'An error occurred whil returning.'
        end
    end
    
end
