variable "containers" {
  type = map(object({
    image = string
    port = number
  }))
}
