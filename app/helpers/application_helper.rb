module ApplicationHelper

  def full_title(page_title)
    base = "PAX TT HQ"
    if page_title.empty?
      base
    else
      "#{base} - #{page_title}"
    end
  end
  
  def open_checkout_count
    Checkout.where(closed: false).size
  end
  
  def admin_label(user)
    if user.nil?
      link_to 'Sign In', signin_url
    else
      admin_name(user)
    end
  end
  
  def admin_name(user)
    if user.nil?
      nil
    else
      sign_out_link(user)
    end
  end
  
  def sign_out_link(user)
    if user.nil?
      nil
    else
      link_to user.name + ' - sign out', signout_path, method: "delete"
    end
  end
  
  def tab_class(tab)
    current = 'current'
    if controller.class == CheckoutsController
      loc = 'checkout'
    elsif controller.class == GamesController && controller.action_name == 'index'
      loc = 'games'
    else
      loc = 'admin'
    end
    
    if loc == tab
      current
    end
  end
  
  def current_pax_label
    current_pax = get_current_pax
    if current_pax
      link_to current_pax.full_name, metrics_path(id: current_pax), { id: 'paxLink' }
    else
      nil
    end
  end
  
  def get_current_pax
    pax = Pax.where({:current => true}).first
    if !pax
      Pax.find(:all, :order => 'start_date DESC').first
    else
      pax
    end
  end
  
  def bool_img(bool)
    if bool
      image_tag("check.png", alt: "true", title: bool)
    else
      image_tag("x.png", alt: "false")
    end
  end
  
end
