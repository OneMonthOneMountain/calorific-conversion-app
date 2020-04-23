const S3Client = require('aws-sdk/clients/s3')
const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const s3 = new S3Client()
const dynamo = new DocumentClient()

const calculateCalories = (activities) => activities.map((activity) => activity.calories).reduce((a, b) => a + b, 0)

const calculateData = (score) => {
    console.log('Scores for user: ', JSON.stringify(score))
    const { UserId: id, Name: name, Activities: activities, CalorieUnit } = score

    const calories = calculateCalories(activities)
    
    const ascent = Math.round((calories / CalorieUnit) * 100)
    const distance =  Math.round((calories / CalorieUnit) * 10) / 10
    
    return { id, name, calories, distance, ascent, activities }
}

const handler = async () => {
    try {
        const rawScores = await dynamo.scan({ TableName: 'scores' }).promise()
        
        console.log(rawScores)
        
        const unsortedScores = rawScores.Items.map(calculateData)
        
        const scores = unsortedScores.sort((a, b) => b.calories - a.calories)

        const totals = scores.reduce((a, b) => {
            a.calories += b.calories
            a.distance += b.distance
            a.ascent += b.ascent
        }, { calories: 0, distance: 0, ascent: 0 })
        
        await s3.putObject({
            Bucket: 'omom-website',
            Key: 'scores.json',
            Body: JSON.stringify({ scores, totals }),
            ContentType: 'application/json',
            CacheControl: 'no-cache'
        }).promise()
    } catch (error) {
        console.log(error)
    }
}

module.exports = { handler }
