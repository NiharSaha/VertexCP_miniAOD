## 1. Environment Setup

First, set up your CMSSW environment and clone the specific branch of the analyzer repository:

```bash
cmsrel CMSSW_13_2_11
cd CMSSW_13_2_11/src
cmsenv 
git clone -b D0analyzer_reproduction_TTree_skimmedEdm git@github.com:NiharSaha/VertexCP_miniAOD.git VertexCompositeAnalysis
cd VertexCompositeAnalysis
./setup
```

## 2. Modifying ZDC Branches

Next, navigate to the ZDC Analysis source directory. *(Note: Ensure you are in your `CMSSW_13_2_11/src/` directory.)*

```bash
cd ../HeavyIonsAnalysis/ZDCAnalysis/src
```

Open `ZDCTreeProducer.cc` and comment out all branches from the ZDC digital TTree **except** `sumPlus` and `sumMinus`. 

**Important:** Do NOT comment out the TTree declaration line: 
`zdcDigiTree = fs->make<TTree>("zdcdigi", "zdc");`

Comment out the following block of code:

```cpp
/*
zdcDigiTree->Branch("n", &zdcDigi.n, "n/I");                                                                                                       
zdcDigiTree->Branch("zside", zdcDigi.zside, "zside[n]/I");                                                                                         
zdcDigiTree->Branch("section", zdcDigi.section, "section[n]/I");                                                                                   
zdcDigiTree->Branch("channel", zdcDigi.channel, "channel[n]/I");                                                                                   
for (int i = 0; i < NZDCTS; i++) {                                                                                                                 
  TString adcTsSt("adcTs"), chargefCTsSt("chargefCTs");                                                                                            
  adcTsSt += i;                                                                                                                                    
  chargefCTsSt += i;                                                                                                                               
                                                                                                                                                   
  zdcDigiTree->Branch(adcTsSt, zdcDigi.adc[i], adcTsSt + "[n]/I");                                                                                 
  zdcDigiTree->Branch(chargefCTsSt, zdcDigi.chargefC[i], chargefCTsSt + "[n]/F");                                                                  
}
*/
```

## 3. Compilation

Return to the main `CMSSW/src` directory and compile the code:

```bash
cd ../../../
scram b -j8
```

## 4. Running Locally

To run a quick local test, navigate to the test directory and execute the configuration file:

```bash
cd VertexCompositeAnalysis/VertexCompositeProducer/test/
cmsRun run_edm_and_ttree_DATA_forD0_withParentFile_andZDC_andEP.py
```

## 5. CRAB Job Submission

For submitting jobs via CRAB, navigate to the crab submission directory:

```bash
cd crab
```

### Important Files:
*   **Template:** `D0_data_submit_skimEDM_template.py` (New CRAB template)
*   **Paths:** `skim_edm_path.txt` (Contains the saved Skim EDM paths)
*   **Submission Script:** `submit_all.sh`

### Configuring User Settings
Before submitting, open `submit_all.sh` and change the `USER SETTINGS` block to match your configuration:

```bash
# ==========================================                                                                                                       
# USER SETTINGS                                                                                                                                    
# ==========================================                                                                                                       
CMS_USER="nsaha" # your user name                                                                                                                  
MIN_DATASET=0    # Min and Max PD will take care of all failed lumi skimEDM                                                                        
MAX_DATASET=0    # MIN_DATASET and MAX_DATASET range [0-31] corresponding to parent miniAOD!                                                       
MANUAL_DATE="Aug11"
INPUT_FILE="skim_edm_path.txt"
CONFIG_DIR="crab_configs"
# ==========================================
```

**Note on Parameters:** 
The most important parameters are `MIN_DATASET` and `MAX_DATASET`, which correspond to `HIPhysicsRawPrime[0-31]`. The script will automatically take all the skim EDMs corresponding to the specific `HIPhysicsRawPrime` range you define.

### Submitting the Jobs
Once your settings are updated, run the submission script:

```bash
./submit_all.sh
```
