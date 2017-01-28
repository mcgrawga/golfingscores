class StaticpagesController < ApplicationController
  def index
    # if they have already hit the landing page in this browser session, show them the same landing page.
    if (cookies[:golfingscores_landing_page].blank?)
      log("No landing page cookie, picking one randomly.")
    	num = rand(1..12)
    	log(num.to_s)
    	if num == 1
        cookies.permanent[:golfingscores_landing_page] = "index"
    		render :index
    	elsif num == 2
        cookies.permanent[:golfingscores_landing_page] = "indexb"
    		render :indexb
      elsif num == 3
        cookies.permanent[:golfingscores_landing_page] = "indexc"
        render :indexc
      elsif num == 4
        cookies.permanent[:golfingscores_landing_page] = "indexd"
        render :indexd
      elsif num == 5
        cookies.permanent[:golfingscores_landing_page] = "indexe"
        render :indexe
      elsif num == 6
        cookies.permanent[:golfingscores_landing_page] = "indexf"
        render :indexf
      elsif num == 7
        cookies.permanent[:golfingscores_landing_page] = "indexg"
        render :indexg
      elsif num == 8
        cookies.permanent[:golfingscores_landing_page] = "indexh"
        render :indexh
      elsif num == 9
        cookies.permanent[:golfingscores_landing_page] = "indexi"
        render :indexi
      elsif num == 10
        cookies.permanent[:golfingscores_landing_page] = "indexj"
        render :indexj
      elsif num == 11
        cookies.permanent[:golfingscores_landing_page] = "indexk"
        render :indexk
    	else
        cookies.permanent[:golfingscores_landing_page] = "indexl"
    		render :indexl
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
  def indexd
  end
  def indexe
  end
  def indexf
  end
  def indexg
  end
  def indexh
  end
  def indexi
  end
  def indexj
  end
  def indexk
  end
  def indexl
  end
  def about
  end
  def notauthorized
  end
end
