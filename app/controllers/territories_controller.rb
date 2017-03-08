class TerritoriesController < ApplicationController
  def index
    @territories = OpenRegister.register('territory', :beta)._all_records
  end
end
