Install apache on webservers minions:
  salt.state:
    - tgt: 'web*'
    - sls:
      - install_apache

Send mine function to loadbalancer:
  salt.function:
    - tgt: '*'
    - name: mine.send
    - arg:
      - network.ip_addrs
    - kwarg:
        interface: eth1
        
Configure the Load Balancer only if the webserv minions are correctly configured:
  salt.state:
    - tgt: 'loadBalancer'
    - sls:
      - haproxy
    - require:
      - salt: Install apache on webservers minions
