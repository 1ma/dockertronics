# SFTP-only container

## Usage

### Start

```bash
$ docker run -p 2222:22 -d 1maa/sftp
f5db3cb05d399b394e21eae886db137e0c474c82c345b94a2f9ff64fbeeeb277
$
```

### Password Authentication

```bash
$ sftp -P 2222 sftp@localhost
The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
ECDSA key fingerprint is SHA256:97gDBZEuiehFwz7Fuzd+MKkl6Hl0VaSqFIQB8Jv52xs.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[localhost]:2222' (ECDSA) to the list of known hosts.
sftp@localhost's password: 
Connected to localhost.
sftp> PUT examples.desktop 
Uploading examples.desktop to /sftp/examples.desktop
examples.desktop                                                            100% 8980     8.8KB/s   00:00    
sftp>
```

### Key Authentication

```bash
$ sftp -i ./id_rsa -P 2222 sftp@localhost
Connected to localhost.
sftp> LS
examples.desktop   
sftp>
```

## Credentials

```
user: sftp
pass: sftp
pkey:
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAvyZ+tehugETrSyMG3Se6lqNXg4MNVKobNozKZBz4YmUQepaX
51vpcDmXUajWrdy2rIh4nNHw02dRJdf3ZhsJxD9SDvitQ/FRqSUGxie/C8GGavyy
cdCrkkAgJBH0nih3+WhZXA1Mq0M61r80pKRJzYftMBOvMobqd+vXpeM5w2yeB2q7
Nw3ZFAauDhjo23140/9ywRQVUVqbiw8nBuDWbn3nOEoTPFl7tH7u8vpWNPNHhw5b
YDg5VTGjY9L4NMeSXCMjggwm6+TuyvctZPsuEtrYjb47brN7cZRxfAivQIQaC5sj
RMnEzQPnhvtdc4OD9n3qK3ARIiW00MycwxaaYQIDAQABAoIBAQC+Dn5qTEKikuQI
fzkx53CkmqBHCKTWi5QnNvF9fTiSTL6HxPggd8ixZvHHpcJeeFfBUKfr9OooqE+M
+yDniva5A+SJMkTEi0qQjVog6CAShkcqVTrv43TUI6JRevDn2IEBoPlIh4i1uFDm
eJLVKOygyQfSh5/o8zBqMDrom/cxEDRetOU7/S+wz0QRFBNnpRToSrR1nk0UkNQc
vjS7cxKtxEKijA/3AMgAhb0OkFa98QNvtTztIyvsorHode+fMMhMfVU4/n+CSTwv
HlkExOjzTyh/foek+OyYx7asbSIRNQI2pcik36nXJ+5ESm6fYPrQIUMRGIoIWA8R
tE/S5wXJAoGBAN8FYEsrfpw88hnRBijb0wBT7g9EF6FQspwx8hfUdKMS5tOwNDNd
rRwYV6rn8UTuyoNOvU6IkCCI2wRVN/qQ/1Sc0rYrnyWbLcevI2QCv78HKxwwQQbf
OhUf+VVm2CdjCDPKgEYRk6LetOZnMAUB19mykFtmB3uKDHYAKY/ZipALAoGBANtq
ofl9eT0FWTejcirqJIpIrNnbl+hp28hTKAnC01vwCQGTCy++TFRKT/XqmEcwpZUw
44YyktKoDv/g5l+v5YkOD9dE255pcId2PVd0rHJuadx5v3Y35OHGQzo9Gwn5OVmb
+Z9YL9gHhhImcl2JTJUp/Zb/ETbSwtsxVO9DA+bDAoGAdwhki9psGjHBOhxBQF+L
r/ob7pP2VMhAfHN/9k4T7tHw132NbvkJoxwu9m4TbSpSdmD5U0g6PNMuqpJdbWQk
k2GcaVTA/Y5kkdadegypkOjfjo0GuAc+9fV526YnqmYGA7aKXluVQ/G/9dWPYKzK
K0xOFipPxhU5b2XIyRlgBl8CgYEAoM2vU4dPeRcYYZxZqXXbvbSxaSB0XhJmzpOS
/kRYXkK2dv7q7dyLWCL2IwYA//t4/rPLq6gYzmX4SDLs4yeoEx/JID0IrzobDEvt
fNC3KU4eK0TWuq8QAR8qWd46mL6b9z5GXS9mMO6ipV6j5kUfaRpTDXx1gzZHNBkd
ZBQ7Ib0CgYBRMHxLeU/wjFRcbRjDhpj8AzdWUQFKWUX3nnJmsB4GnarMasd//HeK
IudixbGRZlLKheZW8/x05RWTqbmKDPQcweJWIOA9LqiN8gXChq8TeGiEBBf9/b3P
dDZFVXqmZVr2X/KVGM6iYLmn4Pt6CIsgvt6Ky0A9WChfbYxnMB4dUQ==
-----END RSA PRIVATE KEY-----
```
