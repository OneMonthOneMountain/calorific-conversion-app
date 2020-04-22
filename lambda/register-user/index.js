const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const handler = async ({ name, calorieUnit }) => {
	await dynamo.put({
	    TableName: 'scores',
	    Item: {
	        "UserId": name,
	        "CalorieUnit": calorieUnit,
	        "Activities": {}
	    }
	}).promise()
}

module.exports = { handler }
