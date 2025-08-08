import os
import boto3
import json
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'StepFuncSampleTable')

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)
    # StepFunctionsのCatchで渡された場合、eventに元入力＋errorが含まれる
    item_id = None
    # 1. SQS経由の元body
    if 'Records' in event:
        records = event.get('Records', [])
        for record in records:
            body = record.get('body', '{}')
            try:
                body_json = json.loads(body)
                item_id = body_json.get('id', 'unknown')
            except Exception:
                item_id = 'unknown'
    # 2. StepFunctionsのCatch経由
    if not item_id and 'id' in event:
        item_id = event.get('id')
    # 3. エラー情報
    error_info = event.get('error', {})
    table.put_item(
        Item={
            'id': item_id or 'unknown',
            'status': 'failure',
            'timestamp': datetime.utcnow().isoformat(),
            'error': json.dumps(error_info)
        }
    )
    return {'result': 'failure_recorded'}
