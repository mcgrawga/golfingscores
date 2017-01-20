class StaticpagesController < ApplicationController
  def index
  	num = rand(1..3)
  	log(num.to_s)
  	if num == 1
  		render :index
  	elsif num == 2
  		render :indexb
  	else
  		render :indexc
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
