# SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
# SPDX-License-Identifier: CC-BY-SA-4.0

variable "external_network_id" {
  type = string
}

variable "fip_pool_name" {
  type = string
}

variable "instance_image_id" {
  type = string
}

variable "instance_flavor_id" {
  type = string
}

variable "number_of_masters" {
  type    = number
  default = 1
}

variable "number_of_workers" {
  type    = number
  default = 2
}

variable "state_path" {
  type    = string
  default = "_state/tf.state"
}

terraform {
  backend "local" {
    path = var.state_path
  }
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
    
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6" 
    }
  }
  required_version = ">= 1.8.8"
}

provider "openstack" {
  enable_logging = true
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_key_file" {
  content = tls_private_key.ssh_key.private_key_openssh
  filename = "_state/id_ed25519"
  file_permission = "0600"
}

resource "openstack_compute_keypair_v2" "instance_ssh_key" {
  name       = "ssh_key_1"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "openstack_networking_router_v2" "router" {
  name                = "router_1"
  external_network_id = var.external_network_id
}

resource "openstack_networking_network_v2" "network" {
  name = "network_1"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "subnet_1"
  network_id      = openstack_networking_network_v2.network.id
  cidr            = "10.13.38.0/24"
  enable_dhcp     = true
  gateway_ip      = "10.13.38.254"
  dns_nameservers = ["1.1.1.1"]
}

resource "openstack_networking_port_v2" "router_port" {
  name           = "router_port"
  admin_state_up = true
  network_id     = openstack_networking_network_v2.network.id

  fixed_ip {
    subnet_id    = openstack_networking_subnet_v2.subnet.id
    ip_address   = "10.13.38.254" 
  }
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  port_id   = openstack_networking_port_v2.router_port.id
}

resource "openstack_networking_secgroup_v2" "all_sg" {
  name = "all_sg"
}

resource "openstack_networking_secgroup_v2" "api_sg" {
  name = "api_sg"
}

resource "openstack_networking_secgroup_v2" "ingress_sg" {
  name = "ingress_sg"
}

resource "openstack_networking_secgroup_v2" "master_sg" {
  name = "master_sg"
}

resource "openstack_networking_secgroup_v2" "worker_sg" {
  name = "worker_sg"
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_all_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.all_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_all_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.all_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_all_http_probe" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1080
  port_range_max    = 1080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.all_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_api_server" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.api_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_ingress_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ingress_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_ingress_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ingress_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_ingress_http_alt" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30080
  port_range_max    = 30080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ingress_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_ingress_https_alt" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30443
  port_range_max    = 30443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ingress_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_ingress_tcp_test" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 31337
  port_range_max    = 31337
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ingress_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_master_to_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_worker_to_worker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.worker_sg.id
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_master_to_worker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_worker_to_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.worker_sg.id
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
}

resource "openstack_networking_port_v2" "master_instance_ports" {
  count              = var.number_of_masters
  name               = "master-${count.index + 1}"
  
  admin_state_up     = true
  network_id         = openstack_networking_network_v2.network.id
  security_group_ids = [
    openstack_networking_secgroup_v2.all_sg.id,
    openstack_networking_secgroup_v2.api_sg.id,
    openstack_networking_secgroup_v2.master_sg.id
  ]

  fixed_ip {
    subnet_id        = openstack_networking_subnet_v2.subnet.id
    ip_address       = "10.13.38.1${count.index + 1}"
  }
}

resource "openstack_networking_port_v2" "worker_instance_ports" {
  count              = var.number_of_workers
  name               = "worker-${count.index + 1}"
  
  admin_state_up     = true
  network_id         = openstack_networking_network_v2.network.id
  security_group_ids = [
    openstack_networking_secgroup_v2.all_sg.id,
    openstack_networking_secgroup_v2.ingress_sg.id,
    openstack_networking_secgroup_v2.master_sg.id
  ]

  fixed_ip {
    subnet_id        = openstack_networking_subnet_v2.subnet.id
    ip_address       = "10.13.38.2${count.index + 1}"
  }
}

resource "openstack_compute_instance_v2" "master_instances" {
  count           = var.number_of_masters
  name            = "master-${count.index + 1}"
  key_pair        = "ssh_key_1"

  image_id        = var.instance_image_id
  flavor_id       = var.instance_flavor_id

  network {
    port          = openstack_networking_port_v2.master_instance_ports[count.index].id
  }
}

resource "openstack_compute_instance_v2" "worker_instances" {
  count           = var.number_of_workers
  name            = "worker-${count.index + 1}"
  key_pair        = "ssh_key_1"

  image_id        = var.instance_image_id
  flavor_id       = var.instance_flavor_id

  network {
    port          = openstack_networking_port_v2.worker_instance_ports[count.index].id
  }
}

resource "openstack_lb_loadbalancer_v2" "lb" {
  name               = "lb_1"
  security_group_ids = [
    openstack_networking_secgroup_v2.all_sg.id,
    openstack_networking_secgroup_v2.api_sg.id,
    openstack_networking_secgroup_v2.ingress_sg.id
  ]
  vip_subnet_id      = openstack_networking_subnet_v2.subnet.id
  vip_address        = "10.13.38.253"
  depends_on         = [openstack_networking_subnet_v2.subnet]
}

resource "openstack_lb_listener_v2" "lb_listener_api_server" {
  name                = "lb_listener_api_server_1"
  protocol            = "TCP"
  protocol_port       = 6443
  loadbalancer_id     = openstack_lb_loadbalancer_v2.lb.id
  timeout_client_data = 65000
}

resource "openstack_lb_listener_v2" "lb_listener_ingress_http" {
  name            = "lb_listener_ingress_http_1"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_listener_v2" "lb_listener_ingress_https" {
  name            = "lb_listener_ingress_https_1"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_pool_v2" "lb_pool_api_server" {
  name        = "lb_pool_api_server_1"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.lb_listener_api_server.id
}

resource "openstack_lb_pool_v2" "lb_pool_ingress_http" {
  name        = "lb_pool_ingress_http_1"
  protocol    = "PROXYV2"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.lb_listener_ingress_http.id
}

resource "openstack_lb_pool_v2" "lb_pool_ingress_https" {
  name        = "lb_pool_ingress_https_1"
  protocol    = "PROXYV2"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.lb_listener_ingress_https.id
}

resource "openstack_lb_member_v2" "lb_members_api_server" {
  count         = var.number_of_masters
  name          = "lb_members_api_server_master-${count.index + 1}_1"
  address       = openstack_compute_instance_v2.master_instances[count.index].access_ip_v4
  pool_id       = openstack_lb_pool_v2.lb_pool_api_server.id
  protocol_port = 6443
}

resource "openstack_lb_member_v2" "lb_members_ingress_http" {
  count         = var.number_of_workers
  name          = "lb_members_ingress_http_worker-${count.index + 1}_1"
  address       = openstack_compute_instance_v2.worker_instances[count.index].access_ip_v4
  pool_id       = openstack_lb_pool_v2.lb_pool_ingress_http.id
  protocol_port = 30080
}

resource "openstack_lb_member_v2" "lb_members_ingress_https" {
  count         = var.number_of_workers
  name          = "lb_members_ingress_https_worker-${count.index + 1}_1"
  address       = openstack_compute_instance_v2.worker_instances[count.index].access_ip_v4
  pool_id       = openstack_lb_pool_v2.lb_pool_ingress_https.id
  protocol_port = 30443
}

resource "openstack_lb_monitor_v2" "lb_monitor_api_server" {
  name        = "lb_monitor_api_server_1"
  type        = "TCP"
  delay       = 1
  timeout     = 1
  max_retries = 3
  pool_id     = openstack_lb_pool_v2.lb_pool_api_server.id
}

resource "openstack_lb_monitor_v2" "lb_monitor_ingress_http" {
  name           = "lb_monitor_ingress_http_1"
  type           = "HTTP"
  url_path       = "/healthz"
  expected_codes = "200"
  delay          = 1
  timeout        = 1
  max_retries    = 3
  pool_id        = openstack_lb_pool_v2.lb_pool_ingress_http.id
}

resource "openstack_lb_monitor_v2" "lb_monitor_ingress_https" {
  name           = "lb_monitor_ingress_https_1"
  type           = "HTTP"
  url_path       = "/healthz"
  expected_codes = "200"
  delay          = 1
  timeout        = 1
  max_retries    = 3
  pool_id        = openstack_lb_pool_v2.lb_pool_ingress_https.id
}

resource "openstack_networking_floatingip_v2" "master_fips" {
  count = var.number_of_masters
  pool  = var.fip_pool_name
}

resource "openstack_networking_floatingip_v2" "worker_fips" {
  count = var.number_of_workers
  pool  = var.fip_pool_name
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool = var.fip_pool_name
}

resource "openstack_networking_floatingip_associate_v2" "master_fip_associations" {
  count       = var.number_of_masters
  floating_ip = openstack_networking_floatingip_v2.master_fips[count.index].address
  port_id     = openstack_networking_port_v2.master_instance_ports[count.index].id

  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}

resource "openstack_networking_floatingip_associate_v2" "worker_fip_associations" {
  count       = var.number_of_workers
  floating_ip = openstack_networking_floatingip_v2.worker_fips[count.index].address
  port_id     = openstack_networking_port_v2.worker_instance_ports[count.index].id

  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}

resource "openstack_networking_floatingip_associate_v2" "lb_fip_association" {
  floating_ip = openstack_networking_floatingip_v2.lb_fip.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id

  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
  {
    number_of_masters = var.number_of_masters
    master_names      = openstack_compute_instance_v2.master_instances.*.name
    master_addresses  = openstack_networking_floatingip_v2.master_fips.*.address
    number_of_workers = var.number_of_workers
    worker_names      = openstack_compute_instance_v2.worker_instances.*.name
    worker_addresses  = openstack_networking_floatingip_v2.worker_fips.*.address
    lb_address        = openstack_networking_floatingip_v2.lb_fip.address
  })

  filename = "_state/inventory"
}
