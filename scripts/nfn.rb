require_relative 'cartodb'
require_relative 'constants'
require 'json'
require 'open-uri'

begin
  table_name = "wdb"
  values = []
  #time for zooniverse url MM-DD-HH (last hour)
  url_time = (Time.now - 60*60).strftime('%m-%d-%H')
  nfn_url = "http://zooniverse-data.s3.amazonaws.com/project_data/notes_from_nature/hourly_dumps/#{url_time}.json"
  transcription_center = "Notes from Nature"

  open(nfn_url) do |nfn|
    nfn.each_line do |line|
      obj = JSON.parse(line)
      subject = obj["subjects"].first
      transcription_id = obj["_id"]["$oid"]
      project = "Notes from Nature"
      user_id = obj["user_id"] ? obj["user_id"]["$oid"] : ""
      user_ip_address = obj["user_ip"]
      subject_id = subject["id"]["$oid"]
      specimen_url = subject["location"]["standard"]
      specimen_image_url = subject["location"]["standard"]
      transcription_timestamp = obj["updated_at"]["$date"]
      transcribed_country = ""
      transcribed_state = ""
      transcribed_county = ""
      transcribed_species = ""
      obj["annotations"].each do |ann|
        case ann["step"]

          when "State/Province"
            transcribed_state = ann["value"]
          when "Country"
            transcribed_country = ann["value"]
          when "County"
            transcribed_county = ann["value"]
          when "Scientific name"
            transcribed_species = ann["value"]
        end
        if ann.has_key? "group"
          project = "NFN - #{ann["group"]["name"]}"
        end
      end
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
      #values.push("('#{id}','#{project}','#{user_id}','#{user_ip_address}','#{subject_id}','#{specimen_url}','#{specimen_image_url}','#{transcription_timestamp}','#{transcribed_country}','#{transcribed_state}','#{transcribed_county}','#{transcribed_species}', '#{Time.now.to_s}')")
    end
  end
  cartodb = CartoDB.new(table_name)
  cartodb.insert values
  cartodb.georeference
rescue
  #error handling
end