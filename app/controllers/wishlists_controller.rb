class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  # GET /wishlists
  # GET /wishlists.json
  def index
    if session[:user_type]=="charity"
      @charity = Charity.find(session[:id])
      @wishlists = @charity.wishlists
    elsif session[:user_type]=="admin"
      redirect_to controller:"wishlists",action:"viewWishlists"
    end
  end

  # GET /wishlists/1
  # GET /wishlists/1.json
  def show
  end

  # GET /wishlists/new
  def new
    @charity = Charity.find(session[:id])
    @wishlist = @charity.wishlists.build
    #@wishlist = Wishlist.new
  end

  # GET /wishlists/1/edit
  def edit
  end

  # POST /wishlists
  # POST /wishlists.json
  def create
    #@wishlist = Wishlist.new(wishlist_params)
    @charity = Charity.find(session[:id])
    @wishlist = @charity.wishlists.build(wishlist_params)

    respond_to do |format|
      if @wishlist.save
        format.html { redirect_to action: :new, notice: 'Wishlist was successfully created.' }
        format.json { render :show, status: :created, location: @wishlist }
      else
        format.html { render :new }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishlists/1
  # PATCH/PUT /wishlists/1.json
  def update
    respond_to do |format|
      if @wishlist.update(wishlist_params)
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @wishlist }
      else
        format.html { render :edit }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlists/1
  # DELETE /wishlists/1.json
  def destroy
    @wishlist.destroy
    respond_to do |format|
      format.html { redirect_to wishlists_url, notice: 'Wishlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def viewWishlists
    @categories_list=Category.all
    @wishlists=Wishlist.all
    @charity=Array.new(@wishlists.count)
    @wishlists.each_with_index{|wishlist,index|
      charityName=Charity.find(wishlist.charity_id)
      @charity[index]=charityName.charityName
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wishlist
      @wishlist = Wishlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_params
      params.require(:wishlist).permit(:wname, :wtype, :isActive, :wdescription, :wphoto, :charity_id)
    end
end