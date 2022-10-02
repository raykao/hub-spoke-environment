variable "prefix" {
  type = string
}

variable "resource_group" {
  
}

variable "subnet_id" {
  type = string
}


variable "subnet_prefix" {
  type = string
}

variable "dockerBridgeCidr" {
  type = string
  default = "172.18.0.0/16"
} 

variable "platformReservedCidr" {
  type = string
  default = "172.19.0.0/16"
}
 
variable "platformReservedDnsIP" {
  type = string
  default = "172.19.0.2"
} 


# variable "container_apps" {
#   type = list(object({
#     name = string
#     image = string
#     tag = string
#     containerPort = number
#     ingress_enabled = bool
#     min_replicas = number
#     max_replicas = number
#     cpu_requests = number
#     mem_requests = string
#   }))

#   default = [ {
#    image = "nginx"
#    name = "nginx"
#    tag = "latest"
#    containerPort = 80
#    ingress_enabled = true
#    min_replicas = 1
#    max_replicas = 2
#    cpu_requests = 0.5
#    mem_requests = "1.0Gi"
#   },
#   {
#    image = "nginx"
#    name = "nginx"
#    tag = "latest"
#    containerPort = 80
#    ingress_enabled = true
#    min_replicas = 1
#    max_replicas = 2
#    cpu_requests = 0.5
#    mem_requests = "1.0Gi"
#   }] 
# }