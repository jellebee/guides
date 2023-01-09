variable "Global" {
  type = map(any)
  default = {
    region             = "eu-central-1"
    Availabilityzone   = "eu-central-1a"
    CompanyAbbrivation = "MC"
    CompanyName        = "MyCompany"
    Environment        = "PROD"
    Managed            = "IAC"
  }
}
variable "s3" {
  type = map(any)
  default = {
    s3name     = "mybucket"
    bucketacl = "private"
    logbucketacl = "public-read"
    s3logsname = "mylogsbucket"
  }
}
