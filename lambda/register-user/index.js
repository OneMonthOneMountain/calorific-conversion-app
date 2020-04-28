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
		const user = JSON.parse(event.body)

		if (!user.id || !user.name || !user.calorieUnit) {
			console.log('User missing a required value: ', JSON.stringify(user))
			throw Error('Missing required value')
		}
		
		await dynamo.update({
			TableName: 'scores',
			Key: {
				UserId: user.id,
			},
			UpdateExpression: 'SET CalorieUnit = :calorieUnit, Name = :name, Activities.#date = :activities',
			ExpressionAttributeNames: {
				'#date': new Date().toISOString().split("T")[0]
			},
			ExpressionAttributeValues: {
				':calorieUnit': user.calorieUnit,
				':name': user.name,
				':activities': user.activities,
			},
		}).promise()
		
		return {
			statusCode: 200,
			headers,
			body: JSON.stringify({ status: 'SUCCESS' })
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
