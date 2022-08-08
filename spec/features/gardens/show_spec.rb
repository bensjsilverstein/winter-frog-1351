require 'rails_helper'

RSpec.describe 'garden show page' do
#   User Story 3, Garden's Plants
# As a visitor
# When I visit an garden's show page
# Then I see a list of plants that are included in that garden's plots
# And I see that this list is unique (no duplicate plants)
# And I see that this list only includes plants that take less than 100 days to harvest
  it "lists all the garden's plants" do
    turing_garden = Garden.create!(name: 'Turing Community Garden', organic: true)
    library_garden = Garden.create!(name: 'Public Library Garden', organic: true)

    ben_plot = turing_garden.plots.create!(number: 25, size: "Large", direction: "East")
    mike_plot = turing_garden.plots.create!(number: 26, size: "Small", direction: "West")
    andre_plot = library_garden.plots.create!(number: 2, size: "Small", direction: "South")
    chris_plot = turing_garden.plots.create!(number: 738, size: "Medium", direction: "West")

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

    visit "/gardens/#{turing_garden.id}"

    expect(page).to have_content("#{cactus.name}")
    expect(page).to have_content("#{squash.name}")
    expect(page).to have_content("#{cucumber.name}")
    expect(page).to have_content("#{pumpkin.name}")
    expect(page).to_not have_content("#{watermelon.name}")
  end

  it "lists all the garden's plants (no duplicates) if they take less than 100 days to harvest" do
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

    visit "/gardens/#{turing_garden.id}"

    expect(page).to have_content("Cactus", count: 1)
    expect(page).to have_content("#{squash.name}")
    expect(page).to have_content("#{pumpkin.name}")
    expect(page).to_not have_content("#{cucumber.name}")
    expect(page).to_not have_content("#{watermelon.name}")
  end
end
