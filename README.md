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

Find instances without a specific tag across all regions
--------------------------------------------------------
`for i in `aws ec2 describe-regions --query 'Regions[].{Name:RegionName}' --output text`; do echo "----- region: $i -----"; aws ec2 describe-instances --region $i --output text --filters Name=instance-state-name,Values=running --query 'Reservations[].Instances[?!not_null(Tags[?Key == `my_tag`].Value)] | [].[InstanceId]'; done`
