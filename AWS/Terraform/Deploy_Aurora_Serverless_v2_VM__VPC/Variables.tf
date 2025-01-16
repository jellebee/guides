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
variable "VPC" {
  type = map(any)
  default = {
    typetag = "VPC"
  }
}
variable "Subnet" {
  type = map(any)
  default = {
    typetag = "Subnet"
  }
}
variable "NetworkInterface" {
  type = map(any)
  default = {
    typetag = "NetworkInterface"
  }
}
variable "EC2" {
  type = map(any)
  default = {
    Ami          = "ami-09042b2f6d07d164a"
    Instancetype = "t2.micro"
  }
}
variable "Aurora" {
  type = map(any)
  default = {
    max_capacity = 1
    min_capacity = 0.5
  }
}
