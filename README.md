## Rechtspraak CLI

A command line interface to extract the Rechtspraak data through curl requests.

### How does it work?

1. Use `get_rechtspraak_id.sh` to get links to court cases.

    - First argument: start date
    - Second argument: end date
    - Third argument: Civil court cases (yes) or all court cases (no)
    - Fourth argument: Output file that stores the ECLI identifiers

```
bash ./get_rechtspraak_id.sh 2020-04-01 2020-04-02 yes links.txt
```

2. Use `get_documents.sh` to get the actual transcriptions of the ruling. 

    - First argument: file containing all ECLI identifiers
    - Second argument: folder (to be created if nonexistent) storing the actual data of all the court cases. 1 file = 1 court case.

```
bash ./get_documents links.txt output
```

