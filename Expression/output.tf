output "list" {
  value = [for x in var.tuple: x]
}

output "set" {
  value = [for x in var.set: x]
}

output "map" {
  value = {for x,y in var.map: y=>x}
}

output "object" {
  value = [for x in var.object: x]
}

output "map_object" {
  value = [for x in var.map-object: x.Name]
}

output "name" {
  value = var.Name!=""?var.Name:"Gaurav"
}
