every :hour do
  runner "FetchCountriesFromCountryRegistersJob.perform_now", output: nil
end

every :hour do
  runner "FetchTerritoriesFromTerritoriesRegistersJob.perform_now", output: nil
end
