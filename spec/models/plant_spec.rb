require 'rails_helper'

RSpec.describe Plant do
  describe 'relationships' do
    it { should have_many(:plot_plants) }
    it { should have_many(:plots).through(:plot_plants) }    
  end
end
