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
        redirect_to @pax, notice: 'Pax was successfully created.'
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
  
=begin
  def destroy
    @pax = Pax.find(params[:id])
    @pax.destroy

    redirect_to paxes_url
  end
=end

end
