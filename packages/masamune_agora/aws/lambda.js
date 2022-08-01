// Lambda関数にS3へのフルアクセス権限を与える必要あり
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

exports.handler = async (event) => {
    let bucket = event['Records'][0]['s3']["bucket"]["name"];
    let source = event['Records'][0]['s3']['object']['key'];
    let targetMatch = source.match(/([a-z0-9A-Z]+)_([a-z0-9A-Z]+)__uid_s_([0-9]+)__uid_e_video_([0-9]+).jpg/);
    let target = targetMatch[2] + ".jpg";
    await s3.copyObject({
        Bucket: bucket, 
        CopySource: "/" + bucket + "/" + source, 
        Key: target
    },function(err, data) {
        if (err) console.log(err, err.stack);
        else     console.log(data);
    }).promise();
    await s3.deleteObject({
        Bucket: bucket, 
        Key : source
    },function(err, data) {
        if (err) console.log(err, err.stack);
        else     console.log(data);
    }).promise();
    return {
        statusCode: 200,
        body: JSON.stringify('success'),
    };
};
