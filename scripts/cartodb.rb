require 'json'
require 'net/http'
require 'open-uri'

class CartoDB

  def initialize(table)
    @table = table
    @api_key = "API KEY GOES HERE"
  end

  def insert(values)
    api_url   = "https://nfn.cartodb.com/api/v2/sql"
    begin_sql = "INSERT INTO #{@table} (transcription_id, project_name, user_id, user_ip, subject_id, specimen_url, specimen_image_url, transcription_timestamp, transcribed_country, transcribed_state, transcribed_county, transcribed_species, upload_timestamp)"
    params = {
        "q"       => begin_sql + " values " + values.join(","),
        "api_key" => @api_key }
    response = Net::HTTP.post_form(URI.parse(api_url), params)
    return response
  end

  def georeference
    params = {
        "kind"          => "ipaddress",
        "column_name"   => "user_ip",
        "formatter"     => "",
        "table_name"    => @table,
        "state"         => "",
        "geometry_type" => "point",
        "api_key"       => @api_key }
    api_url = "https://nfn.cartodb.com/api/v1/geocodings"
    response = Net::HTTP.post_form(URI.parse(api_url), params)
    return response
  end
end