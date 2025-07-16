resource "vsphere_virtual_machine" "k3s_node" {
  count = var.node_count

  name             = "k3s-node-${count.index}"
  resource_pool_id = var.vsphere_resource_pool_id
  datastore_id     = var.vsphere_datastore_id
  num_cpus         = var.vm_config.cpu
  memory           = var.vm_config.memory
  guest_id         = "ubuntu64Guest"

  network_interface {
    network_id = var.vsphere_network_id
  }

  disk {
    label = "disk0"
    size  = var.vm_config.disk
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",
      "mkdir -p ~/.kube",
      "sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config",
      "kubectl create namespace infrastructure"
    ]
  }
}

resource "null_resource" "k3s_init" {
  depends_on = [vsphere_virtual_machine.k3s_node]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ${path.module}/manifests/local-storage.yaml
      kubectl apply -f ${path.module}/manifests/traefik-config.yaml
    EOT
  }
}
