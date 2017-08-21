# cloud-aws
Scripts to be used with Amazon Web Services

aws-certificates.sh
-------------------
* List certificates by expiration date
* Find which ELB has attached selected certificate

Helpful commands to be run manually
* List certificates by expiration date
`aws iam list-server-certificates --output text --query 'ServerCertificateMetadataList[*].[Expiration,ServerCertificateName]' | sort`
* Show certificate details
`aws iam get-server-certificate --server-certificate-name [certificate_name] --output text --query 'ServerCertificate.CertificateBody' | openssl x509 -text | less`
