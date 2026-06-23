import * as AWS from 'aws-sdk';
import { client } from 'pg';
import { context } from 'aws-lambda';

const secredsManager = new AWS.SecretsManager();
const sns = new AWS.SNS();
const rdsProxyEndpoint = process.env.RDS_PROXY_ENDPOINT as string;
const secretArn = process.env.SECRET_ARN as string;
const snsTopicArn = process.env.SNS_TOPIC_ARN as string;
const databaseName = process.env.DATABASE_NAME as string;

export const handler = async (event: any, context: any) => {

    const secret = await getSecret();
    const client = new client({
        host: rdsProxyEndpoint,
        user: secret.username,
        password: secret.password,
        database: databaseName,
        ssl: true,
        port: 5432,
    });


}