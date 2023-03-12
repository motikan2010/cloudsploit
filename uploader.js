const fs = require('fs');
const path = require('path');
const AWS = require('aws-sdk');
AWS.config.update({ region: 'ap-northeast-1' });

const REGION = 'ap-northeast-1';
const MASTER_AWS_ACCESS_KEY_ID = process.env.MASTER_AWS_ACCESS_KEY_ID;
const MASTER_AWS_SECRET_ACCESS_KEY = process.env.MASTER_AWS_SECRET_ACCESS_KEY;
const S3_BUCKET_NAME = process.env.S3_BUCKET_NAME;
const S3_BUCKET_KEY_PREFIX = process.env.S3_BUCKET_KEY_PREFIX;
const RESULT_FILE_NAME = process.env.RESULT_FILE_NAME; // <yyyyMMddHHmmss>_result.json
const COLLECTION_FILE_NAME = process.env.COLLECTION_FILE_NAME; // <yyyyMMddHHmmss>_collection.json

function upload() {
    console.log('Start upload');

    const s3 = new AWS.S3({
        region: REGION,
        credentials: {
            accessKeyId: MASTER_AWS_ACCESS_KEY_ID,
            secretAccessKey: MASTER_AWS_SECRET_ACCESS_KEY,
        },
    });

    s3.upload({
        Bucket: S3_BUCKET_NAME,
        Key: path.posix.join(S3_BUCKET_KEY_PREFIX, RESULT_FILE_NAME),
        Body: fs.createReadStream('/tmp/result.json'),
        ContentType: 'application/json; charset=utf-8'
    }, {
        partSize: 100 * 1024 * 1024,
        queueSize: 4
    }, (err, data) => {
        if (err) {
            console.log(err);
            return;
        }
        console.log(JSON.stringify(data));
    });

    s3.upload({
        Bucket: S3_BUCKET_NAME,
        Key: path.posix.join(S3_BUCKET_KEY_PREFIX, COLLECTION_FILE_NAME),
        Body: fs.createReadStream('/tmp/collection.json'),
        ContentType: 'application/json; charset=utf-8'
    }, {
        partSize: 100 * 1024 * 1024,
        queueSize: 4
    }, (err, data) => {
        if (err) {
            console.log(err);
            return;
        }
        console.log(JSON.stringify(data));
    });
}

upload();
