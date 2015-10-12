require 'nokogiri'
require 'open-uri'
require_relative 'cartodb'

begin
  table_name = "lesherb"
  feed = "http://lesherbonautes.mnhn.fr/contributions/last/days/1/rss"
  transcription_center = "Les Herbonautes"
  values = []
  cartodb = CartoDB.new (table_name)
  last_timestamp = cartodb.get_last_timestamp({"transcription_center" => transcription_center})
  doc = Nokogiri::XML(open(feed))
  doc.xpath('//item').each do |item|
    time = Time.parse(item.css("pubDate").text)
    if time > last_timestamp
      title = item.css("title").text
      transcription_id = ""
      project = item.css("project").text
      #sample title: Orchis anthropophora P02098977  geolocated by phify
      #and phify is what we want (sometimes two words and sometimes split by 'transcribed by')
      user_id = title.split(/transcribed by|geolocated by/).last
      user_ip_address = ""
      subject_id = title.split(" ")[2]
      specimen_url = item.css("link").text
      specimen_image_url = item.css("thumbnailUri").text
      transcription_timestamp = item.css("pubDate").text
      transcribed_country = ""
      transcribed_state = ""
      transcribed_county = ""
      transcribed_species = title.split(" ")[0..1].join(" ")
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
  puts values.length
  puts cartodb.insert values
rescue
  #error handling
end