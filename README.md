
# AWS S3 Bucket Content HTTP Service

This project contains an HTTP service that interacts with an Amazon S3 bucket to list its contents. The service is built using Python and Flask, and it is deployed on AWS using Terraform.

## Part 1: HTTP Service

### Overview

The HTTP service exposes an endpoint to list the contents of an S3 bucket for a given path. The API provides the following functionality:

- **GET `/list-bucket-content/`**: Lists all the top-level contents of the S3 bucket.
- **GET `/list-bucket-content/<path>`**: Lists the contents of the specified path (directory) in the S3 bucket.

### Example Scenarios

Assuming the following structure in the S3 bucket:

```
|_ dir1
|_ dir2
|_ file1
|_ file2
```

- **GET `/list-bucket-content/`**:
  ```json
  {"content": ["dir1", "dir2", "file1", "file2"]}
  ```

- **GET `/list-bucket-content/dir1`**:
  ```json
  {"content": []}
  ```

- **GET `/list-bucket-content/dir2`**:
  ```json
  {"content": ["file1", "file2"]}
  ```

### Setup Instructions

1. **Install dependencies**:
   To run the Flask app locally, install the required Python packages:
   ```bash
   pip install Flask boto3
   ```

2. **Run the application**:
   Run the Flask application by executing the following command:
   ```bash
   python app.py
   ```
   The service will be available at `http://127.0.0.1:5000/`.

### Error Handling

- If invalid or non-existing paths are provided, the service will return an error response indicating the issue.

## Part 2: Terraform Deployment

### Overview

Terraform is used to provision the necessary AWS infrastructure, including EC2 instances and an S3 bucket. The service is deployed to an EC2 instance, which runs the Flask HTTP service.

### Steps for Deployment

1. **Initialize Terraform**:
   First, initialize the Terraform working directory:
   ```bash
   terraform init
   ```

2. **Plan the Deployment**:
   Check what resources will be created with the following command:
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**:
   Apply the configuration to provision resources:
   ```bash
   terraform apply
   ```

   After confirming, Terraform will create the EC2 instance and S3 bucket. The public IP of the EC2 instance will be displayed.

4. **Access the Flask App**:
   Once the EC2 instance is running, access the Flask application using the public IP address:
   ```bash
   http://<EC2_Public_IP>:5000/list-bucket-content/
   

