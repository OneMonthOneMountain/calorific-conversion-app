const S3Client = require('aws-sdk/clients/s3')
const { DocumentClient } = require('aws-sdk/clients/dynamodb')

const s3 = new S3Client()
const dynamo = new DocumentClient()

const handler = async () => {
    const rawScores = await dynamo.scan({
        TableName: 'scores'
    }).promise()
    
    const scores = rawScores.Items.map((score) => ({
        name: score.UserId,
        distance: score.Distance,
        ascent: score.Ascent,
        calories: score.Calories
    }))
    
    await s3.putObject({
        Bucket: 'omom-website',
        Key: 'scores.json',
        Body: JSON.stringify({ scores }),
        ContentType: 'application/json',
        CacheControl: 'no-cache'
    }).promise()
}

module.exports = { handler }
