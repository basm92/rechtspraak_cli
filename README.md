## Rechtspraak CLI

A command line interface to extract the Rechtspraak data through curl requests.

### How does it work?

1. Use `get_rechtspraak_id.sh` to get links to court cases.

    - First argument: start date
    - Second argument: end date
    - Third argument: Civil court cases (yes) or all court cases (no)
    - Fourth argument: Output file that stores the ECLI identifiers

```
bash ./get_rechtspraak_id.sh 2022-02-01 2022-02-05 yes cases.txt
```

2. Use `get_documents.sh` to get the actual transcriptions of the ruling. 

    - First argument: file containing all ECLI identifiers
    - Second argument: folder (to be created if nonexistent) storing the actual data of all the court cases. 1 file = 1 court case.

```
bash ./get_documents.sh cases.txt output
```

3. Each of these court cases can serve as input in `inference.py` to get the structured output in the form of company names of companies involved in that particular court case, if any. 
    - For this to work, you need (i) a [Huggingface](huggingface.co) account
    - (ii) A Huggingface access token
    - (iii) To put that Huggingface access token in a `.env` file as `HF_TOKEN="[your token]"`. 

### `uv` Environment

- To run the `inference.py` script, make sure to install the `uv` package manager and run `uv sync`. This will install and activate the necessary environment to run the script.