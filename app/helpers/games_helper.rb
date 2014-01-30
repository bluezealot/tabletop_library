module GamesHelper

  def select_option_for
    if params[:section_id] && !params[:section_id].empty?
      s = Section.find(params[:section_id])
      [s.name, s.id]
    end
  end

end
