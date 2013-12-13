apiKey = process.env.HUBOT_GOOGLE_PLACES_API_KEY

module.exports = (robot) ->
	robot.respond /(lunch me)(.*)/i, (msg) ->
		lunchMe msg, msg.match[2], (restaurant, address) ->
			msg.send restaurant
			msg.send "http://maps.google.com/maps/api/staticmap?markers=" + escape(address) + "&size=400x400&maptype=roadmap&sensor=false&format=png"

lunchMe = (msg, query, cb) ->
	lunchQuery = query or "lunch"
	msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&location=42.36007439999999%2C-71.0540307&radius=800&sensor=false&types=food&keyword=" + escape(lunchQuery) + "&maxprice=1")
		.get() (err, res, body) ->
			lunchSpots = JSON.parse(body)
			lunchSpots = lunchSpots.results
			if lunchSpots?.length > 0
				lunchSpot = msg.random lunchSpots
				cb lunchSpot.name, lunchSpot.vicinity
			else
				msg.send "No results found"