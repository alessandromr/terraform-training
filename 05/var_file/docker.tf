resource "docker_image" "images" {
  for_each = var.containers

  name = each.value.image
}

resource "docker_container" "containers" {
  for_each = var.containers

  image    = docker_image.images[each.key].image_id
  name     = each.key == "php" ? upper(each.key) : lower(each.key)   //upper-lower functions
  must_run = true

  ports {
    internal = each.value.port
    external = each.value.port
  }
}
