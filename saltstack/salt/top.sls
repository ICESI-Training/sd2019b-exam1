base:
  'minionws1':
    - web
  'minionws2':
    - web2
  'minionlb':
    - balancer
  '*db*':
    - database
  
