class ImportPurchasesController < ApplicationController
  def index
    @import_purchase = Import::Purchase.new
    @imports_purchases = Import::Purchase.all
  end

  def create
    @import_purchase = Import::Purchase.new(permitted_params)

    if @import_purchase.save
      flash[:notice] =
        { Import::Purchase.model_name.human => ['Success created'] }
    else
      flash[:error] = @import_purchase.errors
    end

    redirect_to import_purchases_path
  end

  def show
    @import_purchase = Import::Purchase.find(params[:id])
  end

  private

  def permitted_params
    params.require(:import_purchase).permit(%i[name file])
  end
end
