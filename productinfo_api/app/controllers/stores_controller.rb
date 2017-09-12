class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy,:products,:add_products]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    q=(search_params[:q]||='')
    @stores=Store.search(q)
  end

  def products
    @products=@store.products.joins(:store_product_relations).select("products.* ,store_product_relations.stock")
    puts @products
  end

  def add_products
    puts('add_products')
    _params=add_products_params
    @rel=@store.store_product_relations.find_by(product_id:_params[:product_id])
    @rel||=StoreProductRelation.new(product_id:_params[:product_id],store_id:@store.id,stock:_params[:stock])
    puts(@rel)
    respond_to do |format|
      if @rel.save
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @rel.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      puts(params)
      @store = Store.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:name)
    end

    def search_params
      params.permit(:q)
    end

    def add_products_params
      params.permit(:product_id,:stock)
    end
end
