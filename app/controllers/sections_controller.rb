class SectionsController < ApplicationController
    before_filter :signed_in_user, only: [:index, :show, :new]
    
    def index
        @sections = Section.all
    end

    def show
        @section = Section.find(params[:id])
    end

    def new
        @section = Section.new
    end

    def create
        @section = Section.new(params[:section])

        if @section.save
            redirect_to @section, notice: 'Section was successfully created.'
        else
            render action: "new"
        end
    end
  
end
