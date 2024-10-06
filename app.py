from flask import Flask, jsonify
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

app = Flask(__name__)

BUCKET_NAME = "one2n-assignment-bucket"
s3 = boto3.client('s3')

@app.route('/list-bucket-content/', defaults={'path': ''}, methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path):
    try:
        if path:
            prefix = path if path.endswith('/') else path + '/'
        else:
            prefix = ''

        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=prefix, Delimiter='/')
        if 'Contents' not in response and 'CommonPrefixes' not in response:
            return jsonify({"content": []}), 200
        content = []
        if 'CommonPrefixes' in response:
            for prefix in response['CommonPrefixes']:
                content.append(prefix['Prefix'].rstrip('/'))
        
        if 'Contents' in response:
            for obj in response['Contents']:
                if obj['Key'] != prefix:
                    content.append(obj['Key'].replace(prefix, ''))

        return jsonify({"content": content}), 200
    
    except NoCredentialsError:
        return jsonify({"error": "AWS credentials Not found"}), 500
    except PartialCredentialsError:
        return jsonify({"error": "Incomplete AWS credentials"}), 500
    except ClientError as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)