provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "flask_app" {
  ami           = "ami-069c4aa9307c486df"  # Updated with your chosen AMI ID
  instance_type = "t2.micro"  # Free-tier instance

  tags = {
    Name = "FlaskApp"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y python3
              sudo pip3 install flask boto3
              cd /home/ec2-user
              echo "from flask import Flask, jsonify" > app.py
              echo "import boto3" >> app.py
              echo "app = Flask(__name__)" >> app.py
              echo "s3_client = boto3.client('s3')" >> app.py
              echo "BUCKET_NAME = 'abhichibucket1'" >> app.py
              echo "@app.route('/list-bucket-content/', defaults={'path': ''})" >> app.py
              echo "@app.route('/list-bucket-content/<path:path>')" >> app.py
              echo "def list_bucket_content(path):" >> app.py
              echo "    try:" >> app.py
              echo "        if path:" >> app.py
              echo "            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=path, Delimiter='/')" >> app.py
              echo "        else:" >> app.py
              echo "            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Delimiter='/')" >> app.py
              echo "        if 'Contents' in response:" >> app.py
              echo "            contents = [obj['Key'] for obj in response['Contents']]" >> app.py
              echo "        else:" >> app.py
              echo "            contents = []" >> app.py
              echo "        if 'CommonPrefixes' in response:" >> app.py
              echo "            folders = [prefix['Prefix'] for prefix in response['CommonPrefixes']]" >> app.py
              echo "            contents = contents + folders" >> app.py
              echo "        return jsonify({'content': contents})" >> app.py
              echo "    except Exception as e:" >> app.py
              echo "        return jsonify({'error': str(e)}), 500" >> app.py
              echo "if __name__ == '__main__':" >> app.py
              echo "    app.run(host='0.0.0.0', port=5000)" >> app.py
              nohup python3 /home/ec2-user/app.py &
              EOF
}

output "public_ip" {
  value = aws_instance.flask_app.public_ip
}
