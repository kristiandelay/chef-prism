hosts_defs = {
  "server" => {
    "hostname" => "server",
    "ipaddress" => "10.20.30.40",
    "run_list" => [
      "recipe[chef-solo-search]",
      "role[prism_server]",
      "role[prism_dashboard]",
      "role[prism_client]"
    ]
  },
  "client" => {
    "hostname" => "client",
    "ipaddress" => "10.20.30.41",
    "run_list" => [
      "recipe[chef-solo-search]",
      "role[prism_client]"
    ]
  },
  "graphite" => {
    "hostname" => "graphite",
    "ipaddress" => "10.20.30.42",
    "run_list" => [
      "recipe[chef-solo-search]",
      "role[prism_client]",
      "role[prism_graphite]"
    ]
  }
}

Vagrant.configure("2") do |global_config|
  hosts_defs.each_pair do |name, options|
    global_config.vm.define name do |config|
      config.vm.box = "centos64-64-chef11"
      config.vm.box_url = "http://static.theroux.ca/vagrant/boxes/centos64-64-chef11.box"
      config.vm.hostname = "monitoring-#{options['hostname']}"
      config.vm.network :private_network, ip: options["ipaddress"]
      config.omnibus.chef_version = :latest

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      case name
        when 'server'
          config.vm.network :forwarded_port, guest: 8080, host: 8088
          config.vm.network :forwarded_port, guest: 4567, host: 8888
        when 'graphite'
          config.vm.network :forwarded_port, guest: 80, host: 8880
      end

      config.vm.provision :chef_solo do |chef|
        chef.environments_path = 'environments'
        chef.environment = 'vagrant'
        chef.roles_path = 'roles'
        chef.data_bags_path = 'data_bags'
        chef.run_list = options['run_list']
        chef.json = {
          "sensu" => {
            "version" => "0.12.1-1",
            "use_embedded_ruby" => true,
            "rabbitmq" => {
              "host" => "10.20.30.40"
            },
            "api" => {
              "host" => "10.20.30.40"
            }
          }
        }
      end
    end
  end
end
