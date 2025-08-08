import os
import random
import boto3
import json
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'StepFuncSampleTable')

def lambda_handler(event, context):
    # SQSイベントはRecords配列で渡される
    records = event.get('Records', [])
    for record in records:
        body = record.get('body', '{}')
        try:
            body_json = json.loads(body)
            item_id = body_json.get('id', 'unknown')
        except Exception:
            item_id = 'unknown'

        # 5割で成功、5割で失敗
        if random.random() < 0.5:
            table = dynamodb.Table(TABLE_NAME)
            table.put_item(
                Item={
                    'id': item_id,
                    'status': 'success',
                    'timestamp': datetime.utcnow().isoformat()
                }
            )
        else:
            raise Exception('Simulated Failure')
    return {'result': 'success'}
