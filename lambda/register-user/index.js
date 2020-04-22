const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const handler = async (event) => {
	const user = JSON.parse(event.body)
	
	await dynamo.put({
	    TableName: 'scores',
	    Item: {
	        "UserId": user.name,
	        "CalorieUnit": user.calorieUnit,
	        "Activities": {}
	    }
	}).promise()
	
	return {
		statusCode: 200
	}
}

module.exports = { handler }
