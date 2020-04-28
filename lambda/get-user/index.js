const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const dynamo = new DocumentClient()

const headers = {
	'Access-Control-Allow-Origin': '*',
	'Access-Control-Allow-Headers': '*',
	'Access-Control-Allow-Methods': '*',
	'Content-Type': 'application/json'
}

const handler = async (event) => {
	try {
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
			headers,
			body: JSON.stringify({
				id: Item.UserId,
				name: Item.UserName,
				activities: Item.Activities,
				calorieUnit: Item.CalorieUnit
			})
		}
	} catch (error) {
		return {
			statusCode: 500,
			headers,
			body: error.message
		}
	}
}

module.exports = { handler }
