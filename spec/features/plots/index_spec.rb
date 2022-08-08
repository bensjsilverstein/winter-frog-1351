require 'rails_helper'

RSpec.describe 'plot index page' do
  it "lists all the plots' numbers" do
    turing_garden = Garden.create!(name: 'Turing Community Garden', organic: true)
    library_garden = Garden.create!(name: 'Public Library Garden', organic: true)
    other_garden = Garden.create!(name: 'Main Street Garden', organic: false)

    ben_plot = turing_garden.plots.create!(number: 25, size: "Large", direction: "East")
    mike_plot = turing_garden.plots.create!(number: 26, size: "Small", direction: "West")
    andre_plot = library_garden.plots.create!(number: 2, size: "Small", direction: "South")
    chris_plot = other_garden.plots.create!(number: 738, size: "Medium", direction: "West")

    visit "/plots"

    expect(page).to have_content("#{ben_plot.number}")
    expect(page).to have_content("#{mike_plot.number}")
    expect(page).to have_content("#{andre_plot.number}")
    expect(page).to have_content("#{chris_plot.number}")
  end

  it "lists all the plots' plants" do
    turing_garden = Garden.create!(name: 'Turing Community Garden', organic: true)
    library_garden = Garden.create!(name: 'Public Library Garden', organic: true)
    other_garden = Garden.create!(name: 'Main Street Garden', organic: false)

    ben_plot = turing_garden.plots.create!(number: 25, size: "Large", direction: "East")
    mike_plot = turing_garden.plots.create!(number: 26, size: "Small", direction: "West")
    andre_plot = library_garden.plots.create!(number: 2, size: "Small", direction: "South")
    chris_plot = other_garden.plots.create!(number: 738, size: "Medium", direction: "West")

    cactus = Plant.create!(name: "Cactus", description: "It's just a cactus", days_to_harvest: 1)
    squash = Plant.create!(name: "Squash", description: "A tasty squash", days_to_harvest: 2)
    cucumber = Plant.create!(name: "Cucumber", description: "Good for pickling", days_to_harvest: 3)
    pumpkin = Plant.create!(name: "Pumpkin", description: "Big, orange, and round", days_to_harvest: 4)
    watermelon = Plant.create!(name: "Watermelon", description: "Big, green, red inside", days_to_harvest: 5)

    PlotPlant.create!(plot_id: ben_plot.id , plant_id: cactus.id)
    PlotPlant.create!(plot_id: ben_plot.id , plant_id: squash.id)
    PlotPlant.create!(plot_id: mike_plot.id , plant_id: cucumber.id)
    PlotPlant.create!(plot_id: andre_plot.id , plant_id: pumpkin.id)
    PlotPlant.create!(plot_id: chris_plot.id , plant_id: pumpkin.id)
    PlotPlant.create!(plot_id: chris_plot.id , plant_id: cactus.id)

    visit "/plots"

    within "#plot0" do
      expect(page).to have_content("#{squash.name}")
      expect(page).to have_content("#{cactus.name}")
      expect(page).to_not have_content("#{cucumber.name}")
      expect(page).to_not have_content("#{watermelon.name}")
    end
    within "#plot1" do
      expect(page).to have_content("#{cucumber.name}")
      expect(page).to_not have_content("#{cactus.name}")
    end
    within "#plot2" do
      expect(page).to have_content("#{pumpkin.name}")
      expect(page).to_not have_content("#{cucumber.name}")
    end
    within "#plot3" do
      expect(page).to have_content("#{pumpkin.name}")
      expect(page).to have_content("#{cactus.name}")
      expect(page).to_not have_content("#{cucumber.name}")
    end
  end

  it "has a button to remove a plant from a plot" do
    turing_garden = Garden.create!(name: 'Turing Community Garden', organic: true)
    library_garden = Garden.create!(name: 'Public Library Garden', organic: true)
    other_garden = Garden.create!(name: 'Main Street Garden', organic: false)

    ben_plot = turing_garden.plots.create!(number: 25, size: "Large", direction: "East")
    mike_plot = turing_garden.plots.create!(number: 26, size: "Small", direction: "West")
    andre_plot = library_garden.plots.create!(number: 2, size: "Small", direction: "South")
    chris_plot = other_garden.plots.create!(number: 738, size: "Medium", direction: "West")

    cactus = Plant.create!(name: "Cactus", description: "It's just a cactus", days_to_harvest: 1)
    squash = Plant.create!(name: "Squash", description: "A tasty squash", days_to_harvest: 2)
    cucumber = Plant.create!(name: "Cucumber", description: "Good for pickling", days_to_harvest: 3)
    pumpkin = Plant.create!(name: "Pumpkin", description: "Big, orange, and round", days_to_harvest: 4)
    watermelon = Plant.create!(name: "Watermelon", description: "Big, green, red inside", days_to_harvest: 5)

    PlotPlant.create!(plot_id: ben_plot.id , plant_id: cactus.id)
    PlotPlant.create!(plot_id: ben_plot.id , plant_id: squash.id)
    PlotPlant.create!(plot_id: mike_plot.id , plant_id: cucumber.id)
    PlotPlant.create!(plot_id: andre_plot.id , plant_id: pumpkin.id)
    PlotPlant.create!(plot_id: chris_plot.id , plant_id: pumpkin.id)
    PlotPlant.create!(plot_id: chris_plot.id , plant_id: cactus.id)

    visit "/plots"

    within "#plot0" do
      expect(page).to have_content("#{squash.name}")
      expect(page).to have_content("#{cactus.name}")

      click_on "Remove #{squash.name}"

      expect(page).to_not have_content("Squash")
      expect(page).to have_content("#{cactus.name}")
    end
    within "#plot1" do
      expect(page).to have_content("#{cucumber.name}")

      click_on "Remove #{cucumber.name}"

      expect(page).to_not have_content("#{cucumber.name}")
    end
  end
end
