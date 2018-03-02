class EnricoItemsController < ApplicationController
  def index
    @items = EnricoItem.all
  end

  def new
    @item = EnricoItem.new
  end

  def create
    @item = EnricoItem.create!(item_params)
    redirect_to EnricoItem
  end

  def destroy
    @item = EnricoItem.find(params[:id])
    @item.destroy
    flash[:success] = "Successfully removed #{@item.name}"
    redirect_to EnricoItem
  end


  private

  def item_params
    params.require(:enrico_item).permit(:content)
  end
end
