class SectionsController < ApplicationController
    # GET /sections
    # GET /sections.json
    def index
        @sections = Section.all
    end

    # GET /sections/1
    # GET /sections/1.json
    def show
        @section = Section.find(params[:id])
    end

    # GET /sections/new
    # GET /sections/new.json
    def new
        @section = Section.new
    end

    # POST /sections
    # POST /sections.json
    def create
        @section = Section.new(params[:section])

        if @section.save
            redirect_to @section, notice: 'Section was successfully created.'
        else
            render action: "new"
        end
    end
  
end
