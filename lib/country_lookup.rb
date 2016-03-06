require 'i18n'
require 'countries'

class CountryLookup
  ALIASES = {
    'VS' => 'USA',
    'VK' => 'GBR',
    'VAE' => 'ARE',
  }

  def initialize
    @cache = {}

    ISO3166.configure do |config|
      config.locales = [:nl, :en]
    end

    I18n.enforce_available_locales = false
  end

  def get(country_name)
    country_name = country_name.strip.gsub('v.v.', '')
    @cache[country_name] ||= ALIASES[country_name] || do_lookup(country_name)
  end

private

  def do_lookup(country_name)
    country_name = country_name.downcase.gsub('Ë', 'ë')
    country = ISO3166::Country.find_country_by_name(country_name)
    country.alpha3 if country
  end
end
