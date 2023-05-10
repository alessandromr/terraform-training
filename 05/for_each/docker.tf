locals {
  containers = {
    "nginx" = {
      image = "nginx:alpine"
      port = 80
    },
    "php" = {
      image = "php:fpm-alpine"
      port = 9000
    }
  }
}


resource "docker_image" "images" {
  for_each = local.containers

  name = each.value.image
}

resource "docker_container" "containers" {
  for_each = local.containers

  image    = docker_image.images[each.key].image_id
  name     = upper(each.key)
  must_run = true

  ports {
    internal = each.value.port
    external = each.value.port
  }
}
