import json
import random
import string
import random
import string
import re

def main_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps('Cheers from AWS Lambda!!')
    }