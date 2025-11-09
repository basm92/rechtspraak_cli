## Rechtspraak CLI

A command line interface to extract the Rechtspraak data through curl requests.

### How does it work?

1. Use `get_rechtspraak_id.sh` to get links to court cases.

```
bash ./get_rechtspraak_id.sh 2020-04-01 2020-04-02 links.txt
```

2. Use `get_documents.sh` to get the actual transcriptions of the ruling. 

```
bash ./get_documents links.txt output
```

