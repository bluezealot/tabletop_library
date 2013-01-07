class TitlesController < ApplicationController

    def index
        @titles = Title.all
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
