from flask import Flask, jsonify
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

app = Flask(__name__)

# Initialize a boto3 client for S3
s3_client = boto3.client('s3')

# Set your bucket name here
BUCKET_NAME = "abhichibucket1"

@app.route('/')
def home():
    return "Welcome to the S3 Bucket Content Service. Use /list-bucket-content to view the contents."

@app.route('/list-bucket-content/', defaults={'path': ''})
@app.route('/list-bucket-content/<path:path>')
def list_bucket_content(path):
    try:
        # List objects in the S3 bucket with the given path (directory)
        if path:
            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=path, Delimiter='/')
        else:
            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Delimiter='/')

        if 'Contents' in response:
            contents = [obj['Key'] for obj in response['Contents']]
        else:
            contents = []

        # Get the top-level folders if any
        if 'CommonPrefixes' in response:
            folders = [prefix['Prefix'] for prefix in response['CommonPrefixes']]
            contents = contents + folders

        return jsonify({"content": contents})

    except NoCredentialsError:
        return jsonify({"error": "No AWS credentials found"}), 403
    except PartialCredentialsError:
        return jsonify({"error": "Incomplete AWS credentials"}), 403
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
