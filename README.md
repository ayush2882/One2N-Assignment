# One2N-Assignment

1. Understanding the Problem Statement/Requirement.

2. Created a bucket `one2n-assignment-bucket` with the directory structure as asked.

3. Wrote a Flask Service, exposed an endpoint "http://IP:PORT/list-bucket-content/<path>". This service will list the contents from the bucket created in part 2 and show the contents as per the path specified.

4. Attaching the response from when we ran the service locally. Checked the response by hitting the following endpoints:

   A. GET - http://127.0.0.1:5000/list-bucket-content/
        
      Response: {"content":["dir1","dir2"]}

   B. GET - http://127.0.0.1:5000/list-bucket-content/dir1/

      Response: {"content":[]}

   C. GET - http://127.0.0.1:5000/list-bucket-content/dir2/

      Response: {"content":["CheckSortedArray.py","FrequencyofElements.py"]}
      

5. Wrote Terraform files to create an EC2 instance and deploy the Flask app via user-data. This TF code would generate the below resources:
   A) An IAM role for the EC2 instance to access the S3 bucket.
   B) EC2 instance with user-data to start the flask service.
   C) I have opened ports for EC2 instance to have SSH Access if the user wants to login to the instance, along with opening the port for the Flask app and HTTP access.

6. Ran the below commands to deploy the app on EC2 via Terraform

   terraform init --> To initialise the directory
   terraform plan --> To see the plan for the resources that are to be generated.
   terraform apply --> To create the resources
   

7. Testing the response from the Server's public IP.

   A. GET - http://13.126.30.242:5000/list-bucket-content/
          
        Response: {"content":["dir1","dir2"]}
  
     B. GET - http://13.126.30.242:5000/list-bucket-content/dir1/
  
        Response: {"content":[]}
  
     C. GET - http://13.126.30.242:5000/list-bucket-content/dir2/
  
        Response: {"content":["CheckSortedArray.py","FrequencyofElements.py"]}

10. Design Decisions:

    A) We would get a State File created in local as part of TF operations. If we want, we can store the state file on Remote s3 backend for better state file management and as a best practice. But for the sake of, I am keeping it in my local. 

    B) Also, to provision the infrastructure via TF, I am leveraging Access and Secret keys, which I am saving locally, but it can be done via an IAM role as well as a best practice.

    C) We are storing the files in S3.

    D) We are hosting the Flask app on an EC2 instance.
