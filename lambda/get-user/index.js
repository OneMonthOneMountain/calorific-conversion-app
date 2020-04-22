const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const handler = async (event) => {
	const id = event.queryStringParameters.id

	if (!id) {
		throw Error('Missing id')
	}
	
	const user = await dynamo.get({
	    TableName: 'scores',
	    Item: { "UserId": id }
	}).promise()
	
	return {
		statusCode: 200,
		body: JSON.stringify({
			id: user.UserId,
			name: user.Name,
			activities: user.Activities,
			calorieUnit: user.CalorieUnit
		})
	}
}

module.exports = { handler }
