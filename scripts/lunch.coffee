apiKey = process.env.HUBOT_GOOGLE_PLACES_API_KEY

module.exports = (robot) ->
	robot.respond /(lunch me)(.*)/i, (msg) ->
		lunchMe msg, msg.match[1], (restaurant) ->
			msg.send restaurant

lunchMe = (msg, query, cb) ->
	query = 'lunch' if query == ''
	msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&location=42.36007439999999%2C-71.0540307&radius=800&sensor=false&types=food&maxprice=1&keyword=#{query}%20lunch")
		.get() (err, res, body) ->
			lunchSpots = JSON.parse(body)
			lunchSpots = lunchSpots.results
			if lunchSpots?.length > 0
				lunchSpot = msg.random lunchSpots
				cb lunchSpot.name