# playbook-tttls1.3-testserver


## Set up python

```bash
$ source /path/to/virtualenv/bin/activate

$ pip3 install -r requirements.txt
```


## Deploy

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


### prod

 ```bash
$ python gen_startup.py --user $USER --id_rsa_pub="`cat ~/.ssh/id_rsa.pub`" | pbcopy
```

Paste startup-script to settings.

```bash
$ ansible-playbook -i prod --ask-pass -c paramiko --user $USER certbot.yml https.yml
```

Check [https://thekuwayama.net](https://thekuwayama.net).
