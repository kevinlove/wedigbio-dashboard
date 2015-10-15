require_relative "cartodb"
require_relative "constants"

cartodb = CartoDB.new(TABLE_NAME)
cartodb.get_totals
cartodb.get_totals_by "transcription_center"
