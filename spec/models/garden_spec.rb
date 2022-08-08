require 'rails_helper'

RSpec.describe Garden do
  describe 'relationships' do
    it { should have_many(:plots) }
    it { should have_many(:plot_plants).through(:plots) }
    it { should have_many(:plants).through(:plot_plants) }
  end

  describe 'model methods' do
    it "#harvestable" do
      turing_garden = Garden.create!(name: 'Turing Community Garden', organic: true)
      library_garden = Garden.create!(name: 'Public Library Garden', organic: true)

      ben_plot = turing_garden.plots.create!(number: 25, size: "Large", direction: "East")
      mike_plot = turing_garden.plots.create!(number: 26, size: "Small", direction: "West")
      andre_plot = library_garden.plots.create!(number: 2, size: "Small", direction: "South")
      chris_plot = turing_garden.plots.create!(number: 738, size: "Medium", direction: "West")

      cactus = Plant.create!(name: "Cactus", description: "It's just a cactus", days_to_harvest: 1)
      squash = Plant.create!(name: "Squash", description: "A tasty squash", days_to_harvest: 2)
      cucumber = Plant.create!(name: "Cucumber", description: "Good for pickling", days_to_harvest: 101)
      pumpkin = Plant.create!(name: "Pumpkin", description: "Big, orange, and round", days_to_harvest: 4)
      watermelon = Plant.create!(name: "Watermelon", description: "Big, green, red inside", days_to_harvest: 5)

      PlotPlant.create!(plot_id: ben_plot.id , plant_id: cactus.id)
      PlotPlant.create!(plot_id: ben_plot.id , plant_id: squash.id)
      PlotPlant.create!(plot_id: mike_plot.id , plant_id: cucumber.id)
      PlotPlant.create!(plot_id: andre_plot.id , plant_id: pumpkin.id)
      PlotPlant.create!(plot_id: chris_plot.id , plant_id: pumpkin.id)
      PlotPlant.create!(plot_id: chris_plot.id , plant_id: cactus.id)

      expect(turing_garden.harvestable).to eq([cactus, squash, pumpkin])
      expect(turing_garden.harvestable.include?(cucumber)).to eq(false)

      harvestable_array = turing_garden.harvestable
      expect(harvestable_array.select {|plant| plant == squash}.count).to eq(1)
      expect(harvestable_array.select {|plant| plant == cactus}.count).to eq(1)
      expect(harvestable_array.select {|plant| plant == pumpkin}.count).to eq(1)
    end
  end

end
