from CRABClient.UserUtilities import config #, getUsernameFromSiteDB                                                                                   

# =============================                                                                                                                        
# User-editable section                                                                                                                                
# =============================                                                                                                                        
username = "USER_NAME"
date      = "CURRENT_DATE"
data     = "DATA_NAME"
Dataset = 'DATASET_PATH'

# =============================                                                                                                                        
# CRAB configuration                                                                                                                                   
# =============================                                                                                                                        
config = config()
config.General.workArea = f'D0_MC_2023PbPb_{date}'
config.General.requestName = f'{data}_{date}'
config.General.transferOutputs = True
config.General.transferLogs = True

config.JobType.pluginName = 'Analysis'
config.JobType.psetName = '../run_edm_and_ttree_MC_forD0.py'
#config.JobType.numCores = 2                                                                                                                           
#config.JobType.maxMemoryMB = 4000                                                                                                                     
config.JobType.allowUndistributedCMSSW = True
config.JobType.inputFiles = ['../HeavyIonRPRcd_offline_PbPb2023_wEra.db']

config.Data.inputDataset = Dataset
config.Data.splitting = 'FileBased'
config.Data.inputDBS = 'global'
config.Data.unitsPerJob = 1
config.Data.totalUnits = -1

config.Data.outLFNDirBase = f'/store/user/{username}/D0_MC_2023PbPb_{date}/'
config.Data.publication = True
config.Data.outputDatasetTag = f'{data}_{date}'

config.Site.storageSite = 'T2_US_Purdue'
