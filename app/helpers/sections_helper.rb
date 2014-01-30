module SectionsHelper

  def section_game_count(section)
    Game.where({:section_id => section.id, :returned => false}).count
  end

end
