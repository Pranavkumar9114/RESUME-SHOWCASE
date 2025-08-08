import re
import json
import PyPDF2
import os
# import sys

def extract_policies_from_pdf(pdf_path, output_json_path):

    # print(f"PDF Path: {pdf_path}")
    # print(f"Extracted Data Folder: {output_json_path}")

    file_base = os.path.splitext(os.path.basename(pdf_path))[0]
    # output_json_path = os.path.join(output_json_path, f"{file_base}_policies.json")

    with open(pdf_path, "rb") as file:
        pdf_reader = PyPDF2.PdfReader(file)
        extracted_text = ""

        for page in pdf_reader.pages:
            extracted_text += page.extract_text() + "\n"
    
    start_match = re.search(r"(\d+\.\d+(\.\d+)*)\s+\((L\d|BL)\)\s+.*?\nProfile Applicability", extracted_text, re.DOTALL)
    if not start_match:
        print("No valid policy section found.")
        return

    extracted_text = extracted_text[start_match.start():] 

    policy_pattern = re.compile(
        r"(\d+\.\d+(\.\d+)*)\s+\((L\d|BL)\)\s+(.*?)(\s+\((Automated|Manual)\))?\nProfile Applicability\s*:(.*?)(?=\nDescription|$)",
        re.DOTALL
    )
    
    fields_patterns = {
        "description": r"Description\s*:\s*(.*?)(?=Rationale:|Impact:|Audit:|Remediation:|Default Value:|References:|CIS Controls:|$)",
        "rationale": r"Rationale\s*:\s*(.*?)(?=Impact:|Audit:|Remediation:|Default Value:|References:|CIS Controls:|$)",
        "impact": r"Impact\s*:\s*(.*?)(?=Audit:|Remediation:|Default Value:|References:|CIS Controls:|$)",
        "audit": r"Audit\s*:\s*(.*?)(?=Remediation:|Default Value:|References:|CIS Controls:|$)",
        "remediation": r"Remediation\s*:\s*(.*?)(?=Default Value:|References:|CIS Controls:|$)",
        "default_value": r"Default Value\s*:\s*(.*?)(?=References:|CIS Controls:|$)"  
    }

    i = 0
    policies = []
    for match in policy_pattern.finditer(extracted_text):
        policy_data = {
            "policy_id": match.group(1).strip(), 
            "level": match.group(3).strip(),  
            "title": f"{match.group(4).strip().split('  ')[0]} {match.group(6) if match.group(6) else ''}".strip(),  
            "profile_applicability": match.group(7).strip().replace("\n", " "), 
        }

        policy_text = extracted_text[match.end():]  

        for field, pattern in fields_patterns.items():
            field_match = re.search(pattern, policy_text, re.DOTALL)
            policy_data[field] = field_match.group(1).strip().replace("\n", " ") if field_match else None

        policies.append(policy_data)

    with open(output_json_path, "w", encoding="utf-8") as json_file:
        json.dump(policies, json_file, indent=4, ensure_ascii=False)

    print(f"Extracted {len(policies)} policies to {output_json_path}")
    return len(policies)


