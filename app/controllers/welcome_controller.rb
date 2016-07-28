class WelcomeController < ApplicationController
  def index
  end
  def pick
  end
  def change
  	@change_mapium = Mapium.where(user_id: params[:id]).last
  	
  	if @change_mapium.status == "dead"
  		@change_mapium.update(status: "alive")
  	elsif @change_mapium.status == "alive"
  		@change_mapium.update(status: "dead")
  	end
  	redirect_to '/welcome/pick'
  end
end
