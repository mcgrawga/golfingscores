class StaticpagesController < ApplicationController
  def get_random_landing_page
      num = rand(1..2)
      log(num.to_s)
      if num == 1
        cookies.permanent[:golfingscores_landing_page] = "indexa"
        return :indexa
      else
        cookies.permanent[:golfingscores_landing_page] = "indexb"
        return :indexb
      end
  end

  def index
    landing_page = cookies[:golfingscores_landing_page]
    if (landing_page.blank?)
      log("No landing page cookie, picking one randomly.")
      landing_page = get_random_landing_page
      cookies.permanent[:golfingscores_landing_page] = landing_page
    	render landing_page
    else
      if (landing_page != "indexa" && landing_page != "indexb")
        log("Old landing page cookie, picking one randomly.")
        landing_page = get_random_landing_page
        cookies.permanent[:golfingscores_landing_page] = landing_page
        render landing_page
      else
        log("Landing page cookie found:  " + cookies[:golfingscores_landing_page])
        render landing_page
      end
    end
  end

  def indexa
  end
  def indexb
  end
  def about
  end
  def notauthorized
  end
end
