class PaxesController < ApplicationController
  # GET /paxes
  # GET /paxes.json
  def index
    @paxes = Pax.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paxes }
    end
  end

  # GET /paxes/1
  # GET /paxes/1.json
  def show
    @paxis = Pax.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paxis }
    end
  end

  # GET /paxes/new
  # GET /paxes/new.json
  def new
    @paxis = Pax.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paxis }
    end
  end

  # GET /paxes/1/edit
  def edit
    @paxis = Pax.find(params[:id])
  end

  # POST /paxes
  # POST /paxes.json
  def create
    @paxis = Pax.new(params[:paxis])

    respond_to do |format|
      if @paxis.save
        format.html { redirect_to @paxis, notice: 'Pax was successfully created.' }
        format.json { render json: @paxis, status: :created, location: @paxis }
      else
        format.html { render action: "new" }
        format.json { render json: @paxis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /paxes/1
  # PUT /paxes/1.json
  def update
    @paxis = Pax.find(params[:id])

    respond_to do |format|
      if @paxis.update_attributes(params[:paxis])
        format.html { redirect_to @paxis, notice: 'Pax was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paxis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paxes/1
  # DELETE /paxes/1.json
  def destroy
    @paxis = Pax.find(params[:id])
    @paxis.destroy

    respond_to do |format|
      format.html { redirect_to paxes_url }
      format.json { head :no_content }
    end
  end
end
