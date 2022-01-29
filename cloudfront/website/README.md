# Cloudfront & S3 static website hosting

### Overview

![](images/overview.svg)

### Resources

#### Cloudfront

Cloudfront was setup with OAI and error response redirections

#### S3 Bucket

S3 bucket is private, grating `s3:GetObject` permission to Cloudfront only, through the usage of its Origin Access Identity
