class SectionsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new]
  
  def index
    @sections = Section.all.sort_by(&:id)
  end

  def create
    section = Section.new(name: params[:name])

    success = false
    sec_info = nil

    if section.save
      success = true
      sec_info = {
        name: section.name,
        id: section.id
      }
    end
    
    render json: {
      success: success,
      section: sec_info
    }
  end
  
  def update
    section = Section.find_by_id(params[:id])
    
    success = false
    sec_info = nil
    
    if section && section.update_attributes(name: params[:name])
      success = true
      sec_info = {
        name: section.name,
        id: section.id,
        gamesCount: section.games.size
      }
    end
    
    render json: {
      success: success,
      section: sec_info
    }
  end
  
end
