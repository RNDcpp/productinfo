class ProductsController < ApplicationController
  include Base64Converter
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :convert_base64_data, only:[:create,:update]
  
  # GET /products
  # GET /products.json
  def index
    @product = Product.new
    @store=Store.new
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end
  
  # GET /products/search
  def search
    @products = Product.search(search_params)
  end
  # POST /products
  # POST /products.json
  def create

    @product = Product.new(product_params)
    @product.image_uri=@image
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :ok, location: @product }
        #format.json { render json: @product, status: :ok, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      # if @image is not nil, product is updated with @image
      p product_params
      if @product.update(product_params) and ( @image==nil or @product.update( image_uri: @image ) )
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product}
        #format.json { render json: @product, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
    def convert_base64_data
      if(img = params.require(:product).permit(:image_uri)[:image_uri])
        @image = base64_conversion(img,"#{(Product.last ? Product.last.id+1:1)}")
        puts(@image)
      else
        @image = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      puts(params)
      params.require(:product).permit(:name, :image_uri, :text, :cost)
    end
    
    def search_params
      puts(params)
      params.permit(:q, :max_cost, :min_cost, :search_target, :store_id)
    end
end
