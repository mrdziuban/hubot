apiKey = process.env.HUBOT_GOOGLE_PLACES_API_KEY

module.exports = (robot) ->
	robot.respond /(lunch me)(.*)/i, (msg) ->
		lunchMe msg, msg.match[2], (results) ->
			if results?.length > 0
				lunchSpot = msg.random results
				msg.send lunchSpot.name
				msg.send lunchSpot.vicinity
				msg.send "http://maps.google.com/maps/api/staticmap?markers=" + lunchSpot.geometry.location.lat + "%2C" + lunchSpot.geometry.location.lng + "|1%20south%20market%20street%20boston%20ma%2002109&size=800x400&maptype=roadmap&sensor=false&format=png"
			else
				msg.send "No results found"

lunchMe = (msg, query, cb) ->
	lunchQuery = query or "lunch"
	msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&location=42.36007439999999%2C-71.0540307&radius=800&sensor=false&types=food&keyword=" + escape(lunchQuery) + "&maxprice=1")
		.get() (err, res, body) ->
			lunchSpots = JSON.parse(body)
			results = lunchSpots.results
			if lunchSpots.next_page_token
				setTimeout ->
					msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&sensor=false&pagetoken=#{lunchSpots.next_page_token}")
						.get() (err, res, body) ->
							lunchSpots2 = JSON.parse(body)
							results = results.concat lunchSpots2.results
							if lunchSpots2.next_page_token
								setTimeout ->
									msg.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{apiKey}&sensor=false&pagetoken=#{lunchSpots.next_page_token}")
										.get() (err, res, body) ->
											lunchSpots3 = JSON.parse(body)
											results = results.concat lunchSpots3.results
											cb results
								, 1250
							else
								cb results
				, 1250
			else
				cb results