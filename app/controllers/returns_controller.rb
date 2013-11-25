class ReturnsController < ApplicationController
  before_filter :reset_session, :only => [:new]
  def new
  end

  def get_games
    a_id = params[:a_id].upcase
    games = []

    attendee = get_attendee a_id

    Checkout.where(:attendee_id => a_id, :closed => false, :pax_id => get_current_pax.id).each do |co|
      games << {
        barcode: co.game_id,
        title: co.game.name
      }
    end

    render json: {
        games: games,
        has_games: games.size > 0,
        message: games.size > 0 ? "#{attendee.name} has #{games.size} games checked out." : "#{attendee.name} has no games checked out!"
        }
  end

  def create
    a_id = params[:a_id].upcase
    g_id = params[:g_id].upcase

    return_game(a_id, g_id)
    render json: { success: true }
  end

end
