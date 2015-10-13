require_relative "cartodb"

cartodb = CartoDB.new("wdb")
cartodb.get_totals
cartodb.get_totals_by "transcription_center"