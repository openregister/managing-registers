class CountriesController < ApplicationController
  def index
    @countries = OpenRegister.register('country', :beta)._all_records
  end

  def edit
  end
end
