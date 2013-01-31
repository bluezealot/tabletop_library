class SectionsController < ApplicationController
    before_filter :signed_in_user, only: [:index, :new]
    
    def index
        @sections = Section.all
    end

    def new
        @section = Section.new
    end

    def create
        @section = Section.new(params[:section])

        if @section.save
            flash[:notice] = 'Section was successfully created.'
            redirect_to @section
        else
            render action: "new"
        end
    end
  
end
