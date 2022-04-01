## Certs

Certificate request (.csr file)

```
openssl req -new -newkey rsa:2048 -nodes -keyout ssl.key -out ssl.csr
```

Create the self-signed certificate (.crt file)

```
openssl x509 -req -days 365 -in ssl.csr -signkey ssl.key -out ssl.crt
```
