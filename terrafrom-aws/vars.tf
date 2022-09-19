variable "jenkins-creds" {
  type = object({
    id       = string
    password = string
  })
}

variable "jenkins-config" {
  type = object({
    image = string
    tag   = string
  })
}

variable "gitlab_token" {
  type = string
}

variable "ingressrules" {
  type    = list(number)
  default = [8080, 22]
}