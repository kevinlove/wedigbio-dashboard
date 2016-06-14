require_relative 'cartodb'
require_relative 'constants'
require 'json'
require 'open-uri'


begin
  transcription_center = "Smithsonian"
  url_date = (Time.now - 60*60*24).strftime '%B%d%Y'
  smithsonian_url = "https://transcription.si.edu/json/#{url_date}TransGeo.json"
  username = SMITH_USER
  password = SMITH_PASS
  response = open(smithsonian_url, http_basic_authentication: [username,password]).read
  values = []
  unless response.empty?
    json = JSON.parse(response)
    json["features"].each do |feature|
      properties = feature["properties"]
      transcription_id = ""
      project = properties["projectUrl"]
      user_id = ""
      user_ip_address = ""
      subject_id = ""
      specimen_url = properties["transcribeUrl"]
      specimen_image_url = ""
      transcription_timestamp = properties["date"]
      transcribed_country = ""
      transcribed_state = ""
      transcribed_county = ""
      transcribed_species = ""
      values.push([
                      transcription_id,
                      transcription_center,
                      project,
                      user_id,
                      user_ip_address,
                      subject_id,
                      specimen_url,
                      specimen_image_url,
                      transcription_timestamp,
                      transcribed_country,
                      transcribed_state,
                      transcribed_county,
                      transcribed_species,
                      Time.now.to_s
                  ])
    end
    cartodb = CartoDB.new TABLE_NAME
    cartodb.insert values
  end
rescue

end