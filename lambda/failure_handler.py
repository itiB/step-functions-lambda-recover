import os
import boto3
import json
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'StepFuncSampleTable')

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)
    # StepFunctionsから渡されるeventの形式に応じてidを抽出
    item_id = event.get('id', None)
    # SQS経由の失敗時はRecords配列のbodyからidを抽出
    if not item_id and 'Records' in event:
        records = event.get('Records', [])
        for record in records:
            body = record.get('body', '{}')
            try:
                body_json = json.loads(body)
                item_id = body_json.get('id', 'unknown')
            except Exception:
                item_id = 'unknown'
    if not item_id:
        item_id = 'unknown'
    table.put_item(
        Item={
            'id': item_id,
            'status': 'failure',
            'timestamp': datetime.utcnow().isoformat()
        }
    )
    return {'result': 'failure_recorded'}
