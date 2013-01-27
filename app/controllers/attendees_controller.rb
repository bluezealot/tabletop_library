class AttendeesController < ApplicationController
    before_filter :reset_session, :only => [:index, :new, :show]
    
    def index
        @attendees = Attendee.all
    end

    def show
        @attendee = Attendee.find(params[:id])
    end

    def new
    end

    def create
        bc = params[:a_id].upcase
        if bc.empty? || !/^[a-z]{3}\d{4}[a-z0-9]{2}$/i.match(bc)
            redirect_to new_attendee_path(params), notice:'Invalid barcode.'
        else
            if get_attendee(bc)
                redirect_to new_attendee_path(params), notice: 'Attendee barcode already exists in the system.'
            else
                session[:a_id] = bc
                redirect_to attendees_info_path
            end
        end
    end
    
    def info_get
    end
    
    def info_post
        if params[:handle].empty?
            enforcer = false
        else
            enforcer = true
        end
        
        @attendee = Attendee.new({
            first_name: params[:first_name],
            last_name: params[:last_name],
            handle: params[:handle],
            enforcer: enforcer,
            barcode: session[:a_id]
            })
        
        if @attendee.save
            if session[:redirect] == 'checkout'
                session[:redirect] = nil
                redirect_to checkouts_game_path
            else
                session[:a_id] = nil;
                redirect_to @attendee, notice: 'Attendee was successfully created.'
            end
        else
            redirect_to attendees_info_path(params) #error message needed
        end
    end

=begin
    def destroy
        @attendee = Attendee.find(params[:id])
        @attendee.destroy
    end
=end 
    
end
