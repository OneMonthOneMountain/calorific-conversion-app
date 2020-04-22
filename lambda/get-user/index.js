const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const handler = async (event) => {
	const id = event.queryStringParameters.id

	if (!id) {
		throw Error('Missing id')
	}
	
	const { Item } = await dynamo.get({
	    TableName: 'scores',
	    Key: { "UserId": id }
	}).promise()
	
	return {
		statusCode: 200,
		body: JSON.stringify({
			id: Item.UserId,
			name: Item.Name,
			activities: Item.Activities,
			calorieUnit: Item.CalorieUnit
		})
	}
}

module.exports = { handler }
