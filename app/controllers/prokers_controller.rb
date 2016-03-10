class ProkersController < ApplicationController

	before_action :authenticate_user!, :set_prokerbox
	before_action :destroy_original_prokerbox, :only => [:create, :create_two_card] 
  layout "proker"

	def index
	end

	def create
		@box = Prokerbox.create!(:user_id => current_user.id)
    @box.puts_52_card(1)
    @box.save
    redirect_to prokers_path
	end	

	def create_two_card
		@box = Prokerbox.create!(:user_id => current_user.id)
    @box.puts_52_card(2)
    @box.save
    redirect_to prokers_path
	end	

	def set_scope
		result = @box.draw_two_card_from_prokerbox
		if result
		  current_user.first_number = result[0]
		  current_user.second_number = result[1]
		  current_user.save!
	    redirect_to prokers_path
	  else
	    flash[:alert] = "剩餘的卡片不足 請換一副新牌"	
	    redirect_to prokers_path
	  end    
	end	
  
  def input_card
  	@card1 = params[:number1]
  	@card2 = params[:number2]

  	#把大的數字放前面 
    if @card2 > @card1
    	@card1 = params[:number2]
  	  @card2 = params[:number1]
  	end  

	  if @card2 == @card1 && @box.prokercards.where(:number =>@card1).size < 2
	    flash[:alert] = "撲克牌選擇有誤 請重新選擇"
	    redirect_to prokers_path
	  else  
	  	card1 = @box.prokercards.find_by_number(@card1)
	  	current_user.first_number = @card1
	  	card1.destroy

     	card2 = @box.prokercards.find_by_number(@card2)
	  	current_user.second_number = @card2
      card2.destroy

	  	current_user.save!
	  	redirect_to prokers_path
    end
  end	

  def input_shot
  	@shot = params[:shot]
  	@card = @box.prokercards.find_by_number(@shot)
  	@card.destroy

    redirect_to prokers_path
  end	

	def shot
		@result = "輸"
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

  def reset_user_card
  	if current_user.first_number 
	    current_user.first_number = nil
	  end

    if current_user.second_number 
	    current_user.second_number = nil
	  end
	  current_user.save!
	  redirect_to prokers_path
	end

	private		
	  def destroy_original_prokerbox
	  	if current_user.prokerbox
			  current_user.prokerbox.destroy
			end  
		end

	  def set_prokerbox
	  	if current_user.prokerbox 
		    @box = current_user.prokerbox
		  end
	  end	

end
