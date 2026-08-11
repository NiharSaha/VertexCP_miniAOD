cmsrel CMSSW_13_2_11
cd CMSSW_13_2_11/src
cmsenv 
git clone -b D0analyzer_reproduction_TTree_skimmedEdm git@github.com:NiharSaha/VertexCP_miniAOD.git VertexCompositeAnalysis

cd VertexCompositeAnalysis
./setup

cd /home/saha115/D0_ESE/tmp_Aug11_v2/CMSSW_13_2_11/src/HeavyIonsAnalysis/ZDCAnalysis/src

Edit ZDCTreeProducer.cc to comment out other branches except sumPlus, sumMinus  from ZDC digital TTree. Please be mindful while commenting the branches, don’t comment this line zdcDigiTree = fs->make<TTree>("zdcdigi", "zdc")

/*zdcDigiTree->Branch("n", &zdcDigi.n, "n/I");                                                                                                             
    zdcDigiTree->Branch("zside", zdcDigi.zside, "zside[n]/I");                                                                                                 
    zdcDigiTree->Branch("section", zdcDigi.section, "section[n]/I");                                                                                           
    zdcDigiTree->Branch("channel", zdcDigi.channel, "channel[n]/I");                                                                                           
    for (int i = 0; i < NZDCTS; i++) {                                                                                                                         
      TString adcTsSt("adcTs"), chargefCTsSt("chargefCTs");                                                                                                    
      adcTsSt += i;                                                                                                                                            
      chargefCTsSt += i;                                                                                                                                       
                                                                                                                                                               
      zdcDigiTree->Branch(adcTsSt, zdcDigi.adc[i], adcTsSt + "[n]/I");                                                                                         
      zdcDigiTree->Branch(chargefCTsSt, zdcDigi.chargefC[i], chargefCTsSt + "[n]/F");                                                                          
}*/

From CMSSW/src >> scram b -j8

cd VertexCompositeAnalysis/VertexCompositeProducer/test/

For local run: cmsRun run_edm_and_ttree_DATA_forD0_withParentFile_andZDC_andEP.py

For crab:
cd VertexCompositeAnalysis/VertexCompositeProducer/test/crab
New Crab template: D0_data_submit_skimEDM_template.py
Skim EDM paths are saved: skim_edm_path.txt
Script for submission: submit_all.sh
Change USER settings, and submit the job .\submit_all.sh 
# ==========================================                                                                                                                   
# USER SETTINGS                                                                                                                                                
# ==========================================                                                                                                                   
CMS_USER="nsaha" #your user name                                                                                                                               
MIN_DATASET=0    # Min and Max PD will take care all failed lumi skimEDM                                                                                        
MAX_DATASET=0    # MIN_DATASET and MIN_DATASET range [0-31] corresponding to parent miniAOD!                                                                   
MANUAL_DATE="Aug11"
INPUT_FILE="skim_edm_path.txt"
CONFIG_DIR="crab_configs"
# ==========================================
Important parameters are: MIN_DATASET, MIN_DATASET which corresponds to HIPhysicsRawPrime[0-31].
It will automatically take all the skim elms corresponding to specific HIPhysicsRawPrime.
