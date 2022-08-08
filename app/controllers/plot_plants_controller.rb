class PlotPlantsController < ApplicationController
  def destroy
    @plot = Plot.find(params[:plot_id])
    @plant = Plant.find(params[:plant_id])
    @plot.plot_plants.find_by(plant_id: params[:plant_id]).destroy
    redirect_to plots_path
  end
end
