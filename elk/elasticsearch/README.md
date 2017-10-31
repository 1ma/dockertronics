The dockerized `elasticsearch` process won't start unless you tweak
the `vm.max_map_count` kernel parameter on the host machine.

See https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

```bash
# sysctl -w vm.max_map_count=262144
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf
```
