const S3Client = require('aws-sdk/clients/s3')
const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const s3 = new S3Client()
const dynamo = new DocumentClient()

const calculateCalories = (activities) => Object.values(activities).reduce((a, b) => a + b, 0)

const calculateData = ({ UserId: name, Activities, CalorieUnit }) => {
    const calories = calculateCalories(Activities)
    
    const distance = calories / CalorieUnit
    const ascent = (calories / CalorieUnit) * 100
    
    return { name, calories, distance, ascent }
}

const handler = async () => {
    const rawScores = await dynamo.scan({ TableName: 'scores' }).promise()
    
    const unsortedScores = rawScores.Items.map(calculateData)
    
    const scores = unsortedScores.sort((a, b) => b.calories - a.calories)
    
    await s3.putObject({
        Bucket: 'omom-website',
        Key: 'scores.json',
        Body: JSON.stringify({ scores }),
        ContentType: 'application/json',
        CacheControl: 'no-cache'
    }).promise()
}

module.exports = { handler }
