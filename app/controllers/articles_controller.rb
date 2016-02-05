class ArticlesController < ApplicationController
	before_action :authenticate_user!, :only => [:create,:new]

	def index
	end
	
	def new
		@article = Article.new
	end	

	def create
		@article = current_user.articles.new(article_params)

		if @article.save
			redirect_to articles_path
			flash[:notice] = "建立成功"
		else
		  render :action => :new	
		end  
	end	




  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
      devise_parameter_sanitizer.for(:account_update) << :name
    end

    def article_params
    	params.require(:article).permit(:title,:content,:category_id)
    end	
end
