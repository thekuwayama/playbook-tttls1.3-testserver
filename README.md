### dev

```bash
$ ssh-keygen -f ./id_rsa -t rsa -b 4096 -N ''

$ docker build . -t playbook-tttls1.3-testserver/dev

$ docker run --privileged -d -p 2222:22 -p 4433:443 playbook-tttls1.3-testserver/dev /sbin/init

$ ansible-playbook -i dev private_certificate.yml https.yml
```

Check [https://localhost:4433](https://localhost:4433).

```bash
$ docker ps -ql | xargs docker stop
```
