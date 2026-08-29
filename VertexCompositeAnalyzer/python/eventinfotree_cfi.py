import FWCore.ParameterSet.Config as cms

eventinfoana = cms.EDAnalyzer('EventInfoTreeProducer',
  beamSpotSrc = cms.InputTag("offlineBeamSpot"),
  VertexCollection = cms.InputTag("offlineSlimmedPrimaryVertices"),
  TrackCollection = cms.InputTag("packedPFCandidates"),
  isMC = cms.bool(False),

  selectEvents = cms.untracked.string(""),

  isCentrality = cms.bool(True),
  centralityBinLabel = cms.InputTag("centralityBin","HFtowers"),
  centralitySrc = cms.InputTag("hiCentrality"),

  #threeProngDecay = cms.untracked.bool(True),
                              
  isEventPlane = cms.bool(True),
  eventplaneSrc = cms.InputTag("hiEvtPlaneFlat")
)


