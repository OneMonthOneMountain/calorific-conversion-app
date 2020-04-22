const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const handler = async (event) => {
	const user = JSON.parse(event.body)

	if (!user.id || !user.name || !user.calorieUnit) {
		console.log('User missing a required value: ', JSON.stringify(user))
		throw Error('Missing required value')
	}
	
	await dynamo.put({
	    TableName: 'scores',
	    Item: {
	        "UserId": user.id,
	        "Name": user.name,
	        "CalorieUnit": user.calorieUnit,
	        "Activities": {}
	    }
	}).promise()
	
	return {
		statusCode: 200,
		body: JSON.stringify({ status: 'SUCCESS' })
	}
}

module.exports = { handler }
