Instruction to follow:

```bash
cmsrel CMSSW_13_2_11
cd CMSSW_13_2_11/src
cmsenv 
git clone -b D0analyzer_reproduction_TTree_skimmedEdm git@github.com:NiharSaha/VertexCP_miniAOD.git VertexCompositeAnalysis
cd VertexCompositeAnalysis
./setup.sh 
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


```bash
cd ../../../
scram b -j8 
cd VertexCompositeAnalysis/VertexCompositeProducer/test/ 
voms
cmsRun run_edm_and_ttree_DATA_forD0_withParentFile_andZDC_andEP.py 
```
### Note: please check the EP calib .db file before crab submission
```bash
conddb --db HeavyIonRPRcd_offline_PbPb2023_wEra.db list HeavyIonRPRcd

It should show all run number tags:
-----------------
Since: Run   Insertion Time              Payload                                   Object Type    
-----------  --------------------------  ----------------------------------------  ------------   
1            2026-08-05 20:23:55.318609  4562831ad947a0e4c5cfe74d30aad62f66f8e040  RPFlatParams   
374681       2026-08-05 20:23:57.245569  4562831ad947a0e4c5cfe74d30aad62f66f8e040  RPFlatParams   
374719       2026-08-05 20:24:01.928127  0e67a6bda727365fcb31ab76cda2d9b2458a9025  RPFlatParams   
374730       2026-08-05 20:24:04.534177  795fb4abbdacdd75b55e6ba467d8789302003790  RPFlatParams   
374778       2026-08-05 20:24:10.172928  c832436b777ffa695d93f3eeecda770994854fee  RPFlatParams   
374803       2026-08-05 20:24:15.671367  4f84828ba219fcc5887654b4cd27ece33400a3bd  RPFlatParams   
374810       2026-08-05 20:24:19.590480  6b6cd89b7f063e3d74bc0cf083e2dc0634ae438d  RPFlatParams   
374833       2026-08-05 20:24:23.590761  f7b7047bc5c1fee327a47ec87e4f6d083a58018e  RPFlatParams   
374970       2026-08-05 20:24:26.624637  204b014632ce741581d804466766820dfb8d3591  RPFlatParams   
375007       2026-08-05 20:24:30.761118  0a50e36ed310c26f32dfd92c58aeb532820aa53a  RPFlatParams   
375013       2026-08-05 20:24:33.346638  664df705e1f9bcd4d1e22d138ee9f22c1e34216b  RPFlatParams   
375055       2026-08-05 20:24:35.962786  a5ae511ce289db5353a8ea94e209a15942bb694e  RPFlatParams   
375064       2026-08-05 20:24:39.661477  08b152fc0041c53bc8b995bb2e811a3e33ee6480  RPFlatParams   
375252       2026-08-05 20:24:44.252652  e406b1100bcf881a93c7ee56ac376266c7b72ef8  RPFlatParams   
375391       2026-08-05 20:24:48.936937  26eab18b1524057dd6b75a9812be845c1efa4908  RPFlatParams   
375413       2026-08-05 20:24:52.195281  69920bf8d0c34c06f8e0fde5ea716f57d94f699b  RPFlatParams   
375754       2026-08-05 20:24:55.197402  14f6b1508374680dac808998034b288fc9b2d65f  RPFlatParams   
375790       2026-08-05 20:25:01.110501  fea7fa21e1618637643a20bc6debb15a534995d3  RPFlatParams   
375823       2026-08-05 20:25:04.051395  1a2c30482be906a201e359b60d96142cc8138766  RPFlatParams
-----------------

```


### Important Files for crab:
*   **Template:** `D0_data_submit_skimEDM_template.py` (New CRAB template)
*   **Paths:** `skim_edm_path.txt` (Contains the saved Skim EDM paths)
*   **Submission Script:** `submit_all.sh`

Before submitting, open `submit_all.sh` and change the `USER SETTINGS` block to match your configuration:

```bash

cd crab
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

./submit_all.sh  
```

**Note on Parameters:** 
The most important parameters are `MIN_DATASET` and `MAX_DATASET`, which correspond to `HIPhysicsRawPrime[0-31]`. The script will automatically take all the skim EDMs corresponding to the specific `HIPhysicsRawPrime` range you define. For example, if we have MIN_DATASET=0 and MAX_DATASET=0, it will submit two crab jobs corresponding to two skimEDMs for HIPhysicsRawPrime0. 




