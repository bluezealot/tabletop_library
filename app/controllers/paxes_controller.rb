class PaxesController < ApplicationController
    before_filter :signed_in_user, only: [:index, :show, :new, :edit]

    def index
        @paxes = Pax.all
    end

    def show
        @pax = Pax.find(params[:id])
    end

    def new
        @pax = Pax.new
    end

    def edit
        @pax = Pax.find(params[:id])
    end

    def create
        @pax = Pax.new(params[:pax])

        if @pax.save
            set_to_current_pax @pax
            redirect_to paxes_path, notice: 'Pax was successfully created.'
        else
            render action: "new"
        end
    end

    def update
        @pax = Pax.find(params[:id])

        if @pax.update_attributes(params[:pax])
            redirect_to @pax, notice: 'Pax was successfully updated.'
        else
            render action: "edit"
        end
    end

    def destroy
        if set_to_current_pax params
            redirect_to paxes_path
        else
            flash[:error] = 'Please close all checkouts before changing current PAX.'
            redirect_to paxes_path
        end
    end

    private
  
        def set_to_current_pax(pax)
            current = get_current_pax
            
            if Checkout.where(:pax_id => current.id, :closed => false).count <= 0
                if current
                    current.update_attributes({
                        :current => false
                    })
                end
                new_current = Pax.find(pax[:id])
                new_current.update_attributes({
                    :current => true
                })
            else
                false
            end
        end

end
