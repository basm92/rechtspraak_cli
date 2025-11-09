import os
from openai import OpenAI
import xml.etree.ElementTree as ET
from pydantic import BaseModel, Field, List

# Define pydantic Class
class Company(BaseModel):
    name: str = Field(description="The name of the company.")

class CompanyList(BaseModel):
    companies: List[Company]

# Find xml text of court case
xml_file_path = 'output/ECLI:NL:PHR:2020:314.xml'

# Read and parse the XML file to extract text
tree = ET.parse(xml_file_path)
root = tree.getroot()
# A simple way to get all text content from the XML
court_case_text = "".join(root.itertext())

# Access Huggingface
client = OpenAI(
    base_url="https://router.huggingface.co/v1",
    api_key=os.environ["HF_TOKEN"],
)

completion = client.chat.completions.create(
    model="moonshotai/Kimi-K2-Instruct-0905",
    messages=[
        {
            "role": "system",
            "content": "You are an expert in court cases. You will be given a Dutch court case. You have to provide a list of company names which occur in the court cases as either a plaintiff or dependent, if any."
        }, {
            "role": "user",
            "content": court_case_text
        }
    ],
)

print(completion.choices[0].message)