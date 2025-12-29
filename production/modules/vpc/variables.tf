variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    zone = string
    cidr = string
  }))
}

