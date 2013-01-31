class PaxesController < ApplicationController
    before_filter :signed_in_user, only: [:index, :show, :new, :edit]

    def index
        @paxes = Pax.all
    end

    def new
        @pax = Pax.new
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
