require 'json'
require 'net/http'
require_relative 'cartodb'

begin
  table_name = "symbiota"
  transcription_center = "Symbiota"
  urls = { "bryophyte" => "http://bryophyteportal.org/portal/webservices/dataentryactivity.php",
           "lichen" => "http://lichenportal.org/portal/webservices/dataentryactivity.php",
           "myco" => "http://mycoportal.org/portal/webservices/dataentryactivity.php" }
  cartodb = CartoDB.new table_name

  urls.each do |project, url|
    values = []
    last_timestamp = cartodb.get_last_timestamp({ "transcription_center" => transcription_center,
                                                  "project_name" => project})
    uri      = URI.parse(url + "?days=2&format=json&limit=5000")
    response = JSON.parse(Net::HTTP.get_response(uri).body)

     if response["channel"]["item"]
       response["channel"]["item"].each do |item|
         time = item["pubDate"]
         if Time.parse(time) > last_timestamp
           title = item["title"]
           transcription_id = ""
           user_id = item["creator"]
           user_ip_address = ""
           subject_id = ""
           specimen_url = item["link"]
           specimen_image_url = item["thumbnailUri"]
           transcription_timestamp = time
           transcribed_country = ""
           transcribed_state = ""
           transcribed_county = ""
           transcribed_species = title.include?(" - ") ? title.split(" - ")[0] : ""
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
       end
       cartodb.insert values
     end
  end
rescue

end