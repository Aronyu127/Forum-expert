class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles      
  has_one :prokerbox 

  def check_equal?
		if self.second_number == self.first_number
			true
		else
		  false
		end  	
	end
end
