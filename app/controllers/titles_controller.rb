class TitlesController < ApplicationController
    before_filter :signed_in_user, only: [:index, :edit]
    require 'will_paginate/array'

    def index
        #@games = Game.where(search).order('title_id ASC').paginate(:page => params[:page], :per_page => 10)
        if params[:page]
            _page = params[:page]
        else
            _page = 1
        end
        @titles = Title.all.sort_by(&:title).paginate(:page => _page, :per_page => 10)
    end

    def edit
        @title = Title.find(params[:id])
    end

    def update
        @title = Title.find(params[:id])

        respond_to do |format|
            if @title.update_attributes(params[:title])
                format.html { redirect_to @title, notice: 'Title was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @title.errors, status: :unprocessable_entity }
            end
        end
    end    
    
end
