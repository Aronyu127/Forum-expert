namespace :proker do

  task :newbox => :environment do
  	puts"Create a new card box"
	  pb = Prokerbox.create
	  for i in 1..13
	    Prokercard.create(:number=>i,:suit=>"spades",:prokerbox_id=>pb.id)
	    Prokercard.create(:number=>i,:suit=>"hearts",:prokerbox_id=>pb.id)
	    Prokercard.create(:number=>i,:suit=>"diamonds",:prokerbox_id=>pb.id)
	    Prokercard.create(:number=>i,:suit=>"clubs",:prokerbox_id=>pb.id)
	  end
	  puts"done..."
  end

end