class StaticpagesController < ApplicationController
  def index
    # if they have already hit the landing page in this browser session, show them the same landing page.
    if (cookies[:golfingscores_landing_page].blank?)
      log("No landing page cookie, picking one randomly.")
    	num = rand(1..3)
    	log(num.to_s)
    	if num == 1
        cookies[:golfingscores_landing_page] = "index"
    		render :index
    	elsif num == 2
        cookies[:golfingscores_landing_page] = "indexb"
    		render :indexb
    	else
        cookies[:golfingscores_landing_page] = "indexc"
    		render :indexc
    	end
    else
      log("Landing page cookie found:  " + cookies[:golfingscores_landing_page])
      render cookies[:golfingscores_landing_page]
    end
  end

  def indexb
  end
  def indexc
  end
  def about
  end
  def notauthorized
  end
end
