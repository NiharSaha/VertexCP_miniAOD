from CRABClient.UserUtilities import config #, getUsernameFromSiteDB

# =============================
# User-editable section
# =============================
username = "USER_NAME"
date      = "CURRENT_DATE"
data     = "DATA_NAME"
skimmed_tag = "SKIM_TAG"
inputSkimDataset = 'DATASET_PATH'



# =============================
# CRAB configuration
# =============================
config = config()
config.General.workArea = f'D0_2023PbPb_skimEDM_{date}'
config.General.requestName = f'{data}_{date}_{skimmed_tag}'
config.General.transferOutputs = True
config.General.transferLogs = True

config.JobType.pluginName = 'Analysis'
config.JobType.psetName = '../run_edm_and_ttree_DATA_forD0_withParentFile_andZDC_andEP.py'
#config.JobType.numCores = 2
#config.JobType.maxMemoryMB = 4000
config.JobType.allowUndistributedCMSSW = True
config.JobType.inputFiles = ['../HeavyIonRPRcd_offline_PbPb2023_wEra.db']

config.Data.lumiMask = 'Cert_Collisions2023HI_374288_375823_Golden.json'
config.Data.inputDataset = inputSkimDataset
config.Data.splitting = 'FileBased'
config.Data.useParent = True
config.Data.inputDBS = 'phys03'
config.Data.unitsPerJob = 1
config.Data.totalUnits = -1

config.Data.outLFNDirBase = f'/store/user/{username}/D0_2023PbPb_skimEDM_{date}/' 
config.Data.publication = False
config.Data.outputDatasetTag = f'{data}_{date}_{skimmed_tag}'

config.Site.storageSite = 'T2_US_Purdue'
