require 'json'
require 'net/http'
require 'open-uri'
require 'csv'
require_relative 'constants'

class CartoDB

  def initialize(table)
    @table = table
    @api_key = API_KEY
    @api_url = API_URL
  end


  def insert(values)
    ##################
    #Order of values must be: [
    #     transcription_id,
    #     transcription_center
    #     project,
    #     user_id,
    #     user_ip_address,
    #     subject_id,
    #     specimen_url,
    #     specimen_image_url,
    #     transcription_timestamp,
    #     transcribed_country,
    #     transcribed_state,""
    #     transcribed_county,
    #     transcribed_species,
    #     Time.now.to_s
    # ]
    ######################sud
    begin_sql = "INSERT INTO #{@table} (transcription_id, transcription_center, project_name, user_id, user_ip, subject_id, specimen_url, specimen_image_url, transcription_timestamp, transcribed_country, transcribed_state, transcribed_county, transcribed_species, upload_timestamp)"
    values.map!{ |row| "('" + row.map{ |r| r.gsub("'","") if r.is_a? String }.join("','") + "')" }
    params = {
        "q"       => begin_sql + " values " + values.join(","),
        "api_key" => @api_key }
    response = Net::HTTP.post_form(URI.parse(@api_url), params)
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


  def get_totals
    start = Time.new(2015,10,8,23,50,0,"-04:00")
    csv = "wedigbio.csv"
    query = "SELECT project_name, Count(project_name) FROM #{@table} GROUP BY project_name;"
    json = self.select(query)
    if json["rows"] && json["rows"].length > 0
      hours_elapsed = (Time.now - start)/60/60
      CSV.open(csv, 'ab') do |file|
        json["rows"].each{ |row| file << [ row["project_name"], row["count"], hours_elapsed.round ] }
      end
    end
  end

  def get_totals_by field
    start = START_TIME
    csv = "wedigbio_#{field}.csv"
    query = "SELECT #{field}, Count(#{field}) FROM #{@table} GROUP BY #{field};"
    json = self.select(query)
    if json["rows"] && json["rows"].length > 0
      hours_elapsed = (Time.now - start)/60/60
      CSV.open(csv, 'ab') do |file|
        json["rows"].each{ |row| file << [ row[field], row["count"], hours_elapsed.round ] }
      end
    end
  end

  def get_last_timestamp where
    wheres = where.inject([]){|mem, (key, value)| mem.push("#{key} = '#{value}'") }
    query = "SELECT transcription_timestamp FROM #{@table} WHERE #{wheres.join(" and ")} ORDER BY transcription_timestamp desc limit 1"
    json = self.select(query)
    if json["rows"] && json["rows"].length > 0
      return Time.parse(json["rows"][0]["transcription_timestamp"])
    else
      return Time.new("")
    end
  end

  def select query
    params = { "q" => query,
               "api_key" => @api_key }
    uri = URI.parse(@api_url + "?" + URI.encode_www_form(params))
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body)
  end

end
