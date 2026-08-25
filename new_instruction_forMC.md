Instruction to follow:

```bash
cmsrel CMSSW_13_2_11
cd CMSSW_13_2_11/src
cmsenv 
git clone -b D0analyzer_reproduction_TTree_skimmedEdm git@github.com:NiharSaha/VertexCP_miniAOD.git VertexCompositeAnalysis
cd VertexCompositeAnalysis
./setup.sh 

cd ../
scram b -j8 
cd VertexCompositeAnalysis/VertexCompositeProducer/test/ 
voms
cmsRun run_edm_and_ttree_MC_forD0.py (Run for a few events)
```

### Important Files for crab:
*   **Template:** `D0_MC_submit.py` (New CRAB template)
*   **Paths:** `Prompt_MC.txt.txt` (Contains the Prompt MC paths)
*   **Paths:** `NonPrompt_MC.txt.txt` (Contains the NonPrompt MC paths)
*   **Submission Script:** `submit_all_MC.sh`

Before submitting, open `submit_all.sh` and change the `USER SETTINGS` block to match your configuration:

```bash

cd crab
# ==========================================                                                                                                       
# USER SETTINGS                                                                                                                                    
# ==========================================                                                                                                       
USERNAME="nsaha" # your user name
DATE="Aug24"     # No need to change
INPUT_FILE="Prompt_MC.txt" #For Prompt MC 
INPUT_FILE="NonPrompt_MC.txt" #For NonPrompt MC                                                                                                                            
TEMPLATE_FILE="D0_MC_submit.py" #Nothing to change
# ==========================================

./submit_all_MC.sh  
```




