import os
import boto3
import json
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'StepFuncSampleTable')

def lambda_handler(events, context):
    table = dynamodb.Table(TABLE_NAME)
    item_id = 'unknown'
    for event in events:
      try:
          # SQSのbody形式と同じく、event['body']があればそこからidを抽出
          if 'body' in event:
              inner_json = json.loads(event['body'])
              item_id = inner_json.get('id', 'unknown')
          elif 'id' in event:
              item_id = event.get('id', 'unknown')
      except Exception as e:
          print("[ERROR] Exception:", e)
          item_id = 'unknown'
      # エラー情報
      table.put_item(
          Item={
              'id': item_id or 'unknown',
              'status': 'failure',
              'timestamp': datetime.utcnow().isoformat(),
          }
      )
    return {'result': 'failure_recorded'}
