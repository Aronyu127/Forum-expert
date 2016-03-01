class Prokerbox < ActiveRecord::Base
	has_many :prokercards
	belongs_to :user
  

  def puts_52_card
		for i in 1..13
		    Prokercard.create(:number=>i,:suit=>"spades",:prokerbox_id=>self.id, :position=>i)
		    Prokercard.create(:number=>i,:suit=>"hearts",:prokerbox_id=>self.id, :position=>(13+i))
		    Prokercard.create(:number=>i,:suit=>"diamonds",:prokerbox_id=>self.id, :position=>(26+i))
		    Prokercard.create(:number=>i,:suit=>"clubs",:prokerbox_id=>self.id, :position=>(39+i))
		end
	end	
	

	def check_chance(a,b)
		allcard = self.prokercards.size
	  if a != b
	    if a > b
	    	chance = self.prokercards.where("number < ? and number > ?",a,b).size
      else 
	    	chance = self.prokercards.where("number < ? and number > ?",b,a).size
	    end
	  else
	     c1= self.prokercards.where("number < ?",a).size
	     c2= self.prokercards.where("number > ?",a).size 
	     if c1 > c2 
	       chance = c1
	     else
	       chance = c2
	     end      
	  end	
    probability = (chance.to_f/allcard.to_f).round(2)

	end

	def draw_two_card_from_prokerbox
		unless @box.prokercards.size < 3
			@two_card = []
			@first_card = @box.prokercards.sample
			two_card << @first_card.number
	    @first_card.destroy

			@second_card = @box.prokercards.sample
			two_card << @second_card.number
	    @second_card.destroy
      
      @two_card.sort! {|x,y| y <=> x}
	  else
	  	nil
	  end
	end	




end
