const S3Client = require('aws-sdk/clients/s3')

const s3 = new S3Client()

const handler = async () => {
    const scores = [
        {
            name: "Tom",
            distance: 1,
            ascent: 25,
            calories: 100,
        }
    ]
    
    await s3.putObject({
        Bucket: 'omom-website',
        Key: 'scores.json',
        Body: JSON.stringify({ scores }),
        ContentType: 'application/json',
        CacheControl: 'no-cache'
    }).promise()
}

module.exports = { handler }
