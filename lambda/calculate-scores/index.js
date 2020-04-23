const S3Client = require('aws-sdk/clients/s3')
const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const s3 = new S3Client()
const dynamo = new DocumentClient()

const calculateCalories = (activities) => Object.values(activities).reduce((a, b) => a + b, 0)

const calculateData = (score) => {
    console.log('Score for user: ', JSON.stringify(score))
    const { UserId: id, Name: name, Activities, CalorieUnit } = score

    const calories = calculateCalories(Activities)
    
    const ascent = Math.round((calories / CalorieUnit) * 50)
    const distance =  Math.round((calories / CalorieUnit) * 10) / 10
    
    return { id, name, calories, distance, ascent }
}

const handler = async () => {
    try {
        const rawScores = await dynamo.scan({ TableName: 'scores' }).promise()
        
        console.log(rawScores)
        
        const unsortedScores = rawScores.Items.map(calculateData)
        
        const scores = unsortedScores.sort((a, b) => b.calories - a.calories)
        
        await s3.putObject({
            Bucket: 'omom-website',
            Key: 'scores.json',
            Body: JSON.stringify({ scores }),
            ContentType: 'application/json',
            CacheControl: 'no-cache'
        }).promise()
    } catch (error) {
        console.log(error)
    }
}

module.exports = { handler }
