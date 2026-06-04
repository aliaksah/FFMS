import os
import re

directories = ["R", "R_script"]

replacements = {
    r'\bgmjmcmc\.parallel\b': 'ffms.parallel',
    r'\bmjmcmc\.parallel\b': 'fms.parallel',
    r'\bgmjmcmc_merged\b': 'ffms_merged',
    r'\bmjmcmc_merged\b': 'fms_merged',
    r'\bgmjmcmc_parallel\b': 'ffms_parallel',
    r'\bmjmcmc_parallel\b': 'fms_parallel',
    r'\bgmjmcmc\b': 'ffms_base',
    r'\bmjmcmc\b': 'fms_base',
    r'\bGMJMCMC\b': 'FFMS',
    r'\bMJMCMC\b': 'FMS',
    r'\bmarg\.probs\b': 'sic.probs',
}

for d in directories:
    if os.path.exists(d):
        for filename in os.listdir(d):
            if filename.endswith(".R") or filename.endswith(".Rmd"):
                filepath = os.path.join(d, filename)
                with open(filepath, 'r') as f:
                    content = f.read()
                
                # Exception: don't touch ffms.R wrapper name definition
                if filename == "ffms.R":
                    pass # handled manually or very carefully, wait I'll just run it, ffms is not replaced by ffms_base because the regex is \bgmjmcmc\b!
                
                for k, v in replacements.items():
                    content = re.sub(k, v, content)
                    
                with open(filepath, 'w') as f:
                    f.write(content)

# Also update NAMESPACE if needed
if os.path.exists('NAMESPACE'):
    with open('NAMESPACE', 'r') as f:
        content = f.read()
    for k, v in replacements.items():
        content = re.sub(k, v, content)
    with open('NAMESPACE', 'w') as f:
        f.write(content)
