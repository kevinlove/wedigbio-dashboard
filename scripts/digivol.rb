require_relative 'cartodb'
require_relative 'constants'
require 'json'
require 'open-uri'

if Time.now > START_TIME
  begin
    transcription_center = 'DigiVol'
    digivol_url = "http://volunteer.ala.org.au/ws/wedigbio"
    response = open(digivol_url).read
    values = []
    unless response.empty?
      json = JSON.parse(response)
      json.each do |item|
        transcription_id = item["transcription_id"]
        project = item["project_name"]
        user_id = item["user_id"]
        user_ip_address = item["user_ip_address"]
        subject_id = ""
        specimen_url = item["specimen_url"]
        specimen_image_url = item["specimen_image_url"][0].to_s
        transcription_timestamp = Time.at(item["transcription_timestamp"]/1000).to_s
        transcribed_country = item["transcribed_country"][0].to_s
        transcribed_state = item["transcribed_state"][0].to_s
        transcribed_county = item["transcribed_county"][0].to_s
        transcribed_species = item["transcribed_species"][0].to_s
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
end
