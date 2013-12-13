apiKey = process.env.HUBOT_GOOGLE_PLACES_API_KEY

module.exports = (robot) ->
	robot.respond /(lunch me)(.*)/i, (msg) ->
		lunchMe msg, msg.match[2], (restaurant, address, coords) ->
			msg.send restaurant
			msg.send address
			msg.send "http://maps.google.com/maps/api/staticmap?markers=" + escape(address) + "|1%20south%20market%20street%20boston%20ma%2002109&size=800x400&maptype=roadmap&sensor=false&format=png"

lunchMe = (msg, query, cb) ->
	lunchQuery = query or "lunch"
	msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&location=42.36007439999999%2C-71.0540307&radius=800&sensor=false&types=food&keyword=" + escape(lunchQuery) + "&maxprice=1")
		.get() (err, res, body) ->
			lunchSpots = JSON.parse(body)
			lunchSpots = lunchSpots.results
			if lunchSpots?.length > 0
				lunchSpot = msg.random lunchSpots
				cb lunchSpot.name, lunchSpots.vicinity, lunchSpot.geometry.location.lat + "%2C" + lunchSpot.geometry.location.lng
			else
				msg.send "No results found"