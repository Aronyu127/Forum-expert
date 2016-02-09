class ProkersController < ApplicationController

	before_action :authenticate_user!


	def index
		if current_user.prokerbox
		  @box = current_user.prokerbox
		end 
	end

	def create
		current_user.prokerbox.destroy
		pb = Prokerbox.new(:user_id=>current_user.id)
    pb.save!
    pb.puts_card
    redirect_to prokers_path
	end	

	def set_scope
		@box = current_user.prokerbox

		if @box.prokercards.size >= 3
			@box = current_user.prokerbox
			@first = @box.prokercards.sample
			@first_number = @box.prokercards.sample.number
	    @first.destroy

			@second = @box.prokercards.sample
			@second_number = @box.prokercards.sample.number
	    @second.destroy
      if @first.number > @second.number
		    current_user.first_number = @first.number
		    current_user.second_number = @second.number
		    current_user.save!
      else
      	current_user.first_number = @second.number
		    current_user.second_number = @first.number
		    current_user.save!
		  end  
		  # 把大的數字放第一個

	    redirect_to prokers_path
	  else
	    flash[:alert] = "剩餘的卡片不足 請換一副新牌"	
	    redirect_to prokers_path
	  end    
	end	

	def shot
		@result = "輸"
		@box = current_user.prokerbox
		@shot = @box.prokercards.sample
		@shot_number = @box.prokercards.sample.number
		@shot.destroy #抽出一張

    if params[:chose] #使用者兩張數字一樣
    	if @shot_number == current_user.first_number
        	@result = "中柱*3" #中柱了 不用管選大還小
    	elsif params[:chose]="high" #選大
        if @shot_number > current_user.first_number
        	@result = "贏"
        end	
    	else #選小
    		if @shot_number < current_user.first_number
    			@result = "贏"
        end	
    	end	
	  elsif @shot_number < current_user.first_number && @shot_number > current_user.second_number
	    @result = "贏"
	  elsif @shot_number ==  current_user.first_number || @shot_number ==  current_user.second_number
      @result = "中柱"	  
	  end 
    
	  #判斷結果
   
       
    if  @result == "贏"
	  	flash[:notice] = "發出一張#{@shot_number} 恭喜中獎！"
	  elsif @result == "輸" 	
      flash[:alert] = "發出一張#{@shot_number} 很可惜沒中"
    elsif @result == "中柱"
      flash[:alert] = "發出一張#{@shot_number} 恭喜中柱 罰兩倍！"
    elsif @result == "中柱*3"
      flash[:alert] = "發出一張#{@shot_number} 恭喜中大柱 罰三倍！"
    end 
    redirect_to prokers_path 
	end	


	private		
	

end
