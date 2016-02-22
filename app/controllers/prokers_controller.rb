class ProkersController < ApplicationController

	before_action :authenticate_user!
  layout "proker"

	def index
		if current_user.prokerbox
		  @box = current_user.prokerbox
		end 
	end

	def create
		if current_user.prokerbox
			current_user.prokerbox.destroy
		end	

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
  
  def input_card
  	@box = current_user.prokerbox
  	@card1 = params[:card1]
  	@card2 = params[:card2]

  	#把大的數字放前面 
    if @card2 > @card1
    	@card1 = params[:card2]
  	  @card2 = params[:card1]
  	end  

	  if @card2 == @card1 && @box.prokercards.where(:number =>@card1).size < 2
	    flash[:alert] = "撲克牌選擇有誤 請重新選擇"
	    redirect_to prokers_path
	  else  
	  	card1 = @box.prokercards.find_by_number(@card1)
	  	current_user.first_number = @card1
	  	current_user.save!
	  	card1.destroy

	  	card2 = @box.prokercards.find_by_number(@card2)
	  	current_user.second_number = @card2
	  	current_user.save!
	  	card2.destroy

	  	redirect_to prokers_path
    end
  end	

  def input_shot
  	@box = current_user.prokerbox
  	@shot = params[:shot]
  	@card = @box.prokercards.find_by_number(@shot)
  	@card.destroy

    redirect_to prokers_path
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
    	elsif params[:chose]=="high" #選大
        if @shot_number > current_user.first_number
        	@result = "贏"
        end	
   
    	elsif params[:chose]=="low"#選小
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
