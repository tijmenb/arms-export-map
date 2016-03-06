require_relative 'lib/country_lookup'

require 'csv'
require 'json'

task :default do
  puts "Generating raw file.."
  lookup = CountryLookup.new
  parsed = []

  CSV.foreach('source/Overzicht.uitvoer.militaire.goederen.2004-2014.csv', headers: true) do |row|
    month, day, year = row['afgifte datum'].split('/')

    target_countries = row['land van eindbestemming'].split(', ').map do |country|
      lookup.get(country)
    end

    next unless target_countries.any?

    parsed << {
      date: Date.parse([year, month, day].join('/')),
      countries: target_countries,
      amount: row['waarde (€)'].to_i,
      description: row['goederen omschrijving'],
    }
  end

  File.open("data/exports.json", "w") do |f|
    f.write JSON.dump(parsed)
  end

  puts "Finished."
end

task :countries => [:default] do
  puts "Generating country aggregrates.."
  data = JSON.parse(File.read("data/exports.json"))

  country_names = ISO3166::Country.all.map(&:alpha3)

  countries = {}

  country_names.each do |cid|
    countries[cid] = { count: 0, total_amount: 0 }
  end

  data.each do |entry|
    country = entry['countries'].first
    next unless country

    countries[country][:count] += 1
    countries[country][:total_amount] += entry['amount']
  end

  File.open("data/countries.json", "w") do |f|
    f.write JSON.dump(countries)
  end
end
