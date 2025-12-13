import chatlas as ctl
import xml.etree.ElementTree as ET
from typing import List, Optional
from pydantic import BaseModel, Field
import pandas as pd
import json
import pathlib

# Helper
def companylist(cl):
    return [c.name for c in cl.companies]

# Define pydantic Class
class Company(BaseModel):
    name: Optional[str] = Field(
        default=None,
        description="The name of the company."
    )

class CompanyList(BaseModel):
    companies: List[Company] = Field(
        default_factory=list,
        description="A list of companies involved in the court case. Returns an empty list if none are found."
    )

# Find xml text of court cases
def parse_cc_text(file_path):
    """
    Parses the first 5000 characters of a court case.
    """
    tree = ET.parse(file_path)
    root = tree.getroot()
    court_case_text = "".join(root.itertext())
    short_text = court_case_text[0:5000]

    return short_text

xml_files = list(pathlib.Path("output_230101_231001/").rglob("*.xml"))
results = [parse_cc_text(f) for f in xml_files]

# Chatlas to process
chat = ctl.ChatOpenAI(
    model="gpt-5-nano",
    system_prompt="You are an expert in court cases. You will be given a Dutch court case. You have to provide a list of company names which occur in the court cases as either a plaintiff or dependent, if any."
)

res = ctl.batch_chat_structured(
    chat, 
    prompts=results[1:5000], 
    path='batch_state.json',
    data_model=CompanyList
    )

# Export to .json
records = [
    {
        "filename": f.name,
        "companies": companylist(r)
    }
    for f, r in zip(xml_files[1:5000], res)
]

with open("courtcases_companies.json", "w") as fh:
    json.dump(records, fh, indent=2)
