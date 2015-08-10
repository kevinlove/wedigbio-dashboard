#WeDigBio Dashboard Features:

* Maps of cumulative participant activity across project and events
* Heat-map of collection localities transcribed
* Stream of thumbnail images that have been transcribed 
* Timeline of transcribed records by collection date
* Leaderboard



_RSS feeds should look something like this:_

```xml
<item>
<project>Project name, if more than one project on this feed</project> 
<title>Specimen name or Collector Name/Collection Name</title>
<link>Specimen page URI (on transcribing site) </link>
<thumbnailUri>Thumbnail URI</thumbnailUri> 
<decimalLatitude>Lat. of collecting event </decimalLatitude>
<decimalLongitude>Long. of collecting event</decimalLongitude> 
<decimalLatitudeTranscribing>Transcription Lat</decimalLatitudeTranscribing>
<decimalLongitudeTranscribing>Transcription Long</decimalLongitudeTranscribing>
<dwc:verbatimEventDate>Time or period of collecting</dwc:verbatimEventDate> 
<pubDate>Timestamp of transcription</pubDate>
<dc:creator>User or project who create this transcription</dc:creator>
</item>
```

##Current Dashboard Data Providers

[Herbaria@Home](http://beta.herbariaunited.org/recentthumbnail.rss.php)
```xml
<item>
<title>Blysmus compressus</title>
<link>http://herbariaunited.org/specimen/395585/</link>
<description>
<![CDATA[
<a href="http://herbariaunited.org/specimen/395585/"><img src="http://herbariaunited.org/sheets/SLBI/imgcache/4/45874/thumb_45874.jpg" ></a>
]]>
</description>
<dc:creator>hollyrebecca @herbariumathome</dc:creator>
<dc:date>2015-06-22T11:58:24+00:00</dc:date>
</item>
```

[LesHebonautes] (http://lesherbonautes.mnhn.fr/contributions/last/rss)

```xml
<item>
<title>
Triticum cristatum P03218978 geolocated by jonnard
</title>
<project>Histoires de blés</project>
<link>
http://lesherbonautes.mnhn.fr/specimens/MNHN/P/P03218978
</link>
<pubDate>Mon, 15 Jun 2015 21:40:53 +0200</pubDate>
<thumbnailUri>
http://lesherbonautes.mnhn.fr/tuile/MNHN/P/P03218978/tile_0_0_0.jpg
</thumbnailUri>
<decimalLatitude>47.48639</decimalLatitude>
<decimalLongitude>19.041111</decimalLongitude>
<decimalLatitudeTranscribing>48.841461</decimalLatitudeTranscribing>
<decimalLongitudeTranscribing>2.356335</decimalLongitudeTranscribing>
<labelCompleted>true</labelCompleted>
</item>
```

[Notes From Nature](https://api.zooniverse.org/projects/notes_from_nature)

```javascript
{
id: "511410da3ae740c3ec000001",
activated_subjects_at: "2015-08-10T20:00:24Z",
bucket: "zooniverse-static",
bucket_path: "www.notesfromnature.org",
classification_count: 822452,
complete_count: 158551,
created_at: "2013-04-18T18:34:27Z",
display_name: "Notes From Nature",
groups: {
5170103b3ae74027cf000002: {
classification_count: 243275
},
517010563ae74027d3000002: {
classification_count: 481486
},
520903d03ae740842f000002: {
classification_count: 13954,
rows_transcribed: 337327
},
5266c83a3ae740d5e3000002: {
classification_count: 81767
},
55ada648469d922927000002: {
classification_count: 1970
}
},
name: "notes_from_nature",
site_prefix: "NN",
updated_at: "2013-04-18T18:34:27Z",
user_count: 7881,
workflow_name: "primary",
zooniverse_id: 22
}
```
