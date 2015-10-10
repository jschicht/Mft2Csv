CREATE DATABASE IF NOT EXISTS Ntfs
	CHARACTER SET 'utf8'
	COLLATE 'utf8_general_ci';

USE Ntfs;

CREATE TABLE IF NOT EXISTS mft2csv(
   `RecordOffset`               VARCHAR(18) NOT NULL 
  ,`Signature`                  VARCHAR(4) NOT NULL
  ,`IntegrityCheck`             VARCHAR(3)
  ,`Style`                      VARCHAR(8)
  ,`HEADER_MFTREcordNumber`     INTEGER
  ,`HEADER_SequenceNo`          INTEGER
  ,`Header_HardLinkCount`       INTEGER
  ,`FN_ParentReferenceNo`       INTEGER
  ,`FN_ParentSequenceNo`        INTEGER
  ,`FN_FileName`                VARCHAR(255)
  ,`FilePath`                   MEDIUMTEXT
  ,`HEADER_Flags`               VARCHAR(32)
  ,`RecordActive`               VARCHAR(9)
  ,`FileSizeBytes`              BIGINT 
  ,`SI_FilePermission`          VARCHAR(64)
  ,`FN_Flags`                   VARCHAR(64)
  ,`FN_NameType`                VARCHAR(9)
  ,`ADS`                        INTEGER 
  ,`SI_CTime`                   DateTime(6)
  ,`SI_ATime`                   DateTime(6)
  ,`SI_MTime`                   DateTime(6)
  ,`SI_RTime`                   DateTime(6)
  ,`MSecTest`                   TINYINT(1)
  ,`FN_CTime`                   DateTime(6)
  ,`FN_ATime`                   DateTime(6)
  ,`FN_MTime`                   DateTime(6)
  ,`FN_RTime`                   DateTime(6)
  ,`CTimeTest`                  TINYINT(1)
  ,`FN_AllocSize`               BIGINT
  ,`FN_RealSize`                BIGINT
  ,`FN_EaSize`                  BIGINT
  ,`SI_USN`                     BIGINT
  ,`DATA_Name`                  VARCHAR(100)
  ,`DATA_Flags`                 VARCHAR(32)
  ,`DATA_LengthOfAttribute`     INTEGER
  ,`DATA_IndexedFlag`           TINYINT 
  ,`DATA_VCNs`                  BIGINT 
  ,`DATA_NonResidentFlag`       INTEGER 
  ,`DATA_CompressionUnitSize`   INTEGER 
  ,`HEADER_LSN`                 BIGINT
  ,`HEADER_RecordRealSize`      INTEGER
  ,`HEADER_RecordAllocSize`     INTEGER
  ,`HEADER_BaseRecord`          INTEGER
  ,`HEADER_BaseRecSeqNo`        INTEGER
  ,`HEADER_NextAttribID`        VARCHAR(6)
  ,`DATA_AllocatedSize`         BIGINT 
  ,`DATA_RealSize`              BIGINT 
  ,`DATA_InitializedStreamSize` BIGINT 
  ,`SI_HEADER_Flags`            VARCHAR(32)
  ,`SI_MaxVersions`             INTEGER
  ,`SI_VersionNumber`           INTEGER
  ,`SI_ClassID`                 INTEGER
  ,`SI_OwnerID`                 INTEGER
  ,`SI_SecurityID`              INTEGER
  ,`SI_Quota`                   INTEGER
  ,`FN_CTime_2`                 DateTime(6)
  ,`FN_ATime_2`                 DateTime(6)
  ,`FN_MTime_2`                 DateTime(6)
  ,`FN_RTime_2`                 DateTime(6)
  ,`FN_AllocSize_2`             BIGINT
  ,`FN_RealSize_2`              BIGINT
  ,`FN_EaSize_2`                BIGINT
  ,`FN_Flags_2`                 VARCHAR(64)
  ,`FN_NameLength_2`            VARCHAR(255)
  ,`FN_NameType_2`              VARCHAR(9)
  ,`FN_FileName_2`              VARCHAR(255)
  ,`GUID_ObjectID`              VARCHAR(38)
  ,`GUID_BirthVolumeID`         VARCHAR(38)
  ,`GUID_BirthObjectID`         VARCHAR(38)
  ,`GUID_BirthDomainID`         VARCHAR(38)
  ,`VOLUME_NAME_NAME`           VARCHAR(100)
  ,`VOL_INFO_NTFS_VERSION`      VARCHAR(3)
  ,`VOL_INFO_FLAGS`             VARCHAR(64)
  ,`FN_CTime_3`                 DateTime(6)
  ,`FN_ATime_3`                 DateTime(6)
  ,`FN_MTime_3`                 DateTime(6)
  ,`FN_RTime_3`                 DateTime(6)
  ,`FN_AllocSize_3`             BIGINT
  ,`FN_RealSize_3`              BIGINT
  ,`FN_EaSize_3`                BIGINT
  ,`FN_Flags_3`                 VARCHAR(64)
  ,`FN_NameLength_3`            INTEGER
  ,`FN_NameType_3`              VARCHAR(9)
  ,`FN_FileName_3`              VARCHAR(255)
  ,`DATA_Name_2`                VARCHAR(100)
  ,`DATA_NonResidentFlag_2`     INTEGER 
  ,`DATA_Flags_2`               VARCHAR(32)
  ,`DATA_LengthOfAttribute_2`   INTEGER 
  ,`DATA_IndexedFlag_2`         INTEGER 
  ,`DATA_StartVCN_2`            BIGINT 
  ,`DATA_LastVCN_2`             BIGINT 
  ,`DATA_VCNs_2`                BIGINT 
  ,`DATA_CompressionUnitSize_2` INTEGER 
  ,`DATA_AllocatedSize_2`       BIGINT 
  ,`DATA_RealSize_2`            BIGINT 
  ,`DATA_InitializedStreamSize_2` BIGINT 
  ,`DATA_Name_3`                VARCHAR(100)
  ,`DATA_NonResidentFlag_3`     INTEGER
  ,`DATA_Flags_3`               VARCHAR(32)
  ,`DATA_LengthOfAttribute_3`   INTEGER
  ,`DATA_IndexedFlag_3`         INTEGER
  ,`DATA_StartVCN_3`            BIGINT
  ,`DATA_LastVCN_3`             BIGINT
  ,`DATA_VCNs_3`                BIGINT
  ,`DATA_CompressionUnitSize_3` INTEGER
  ,`DATA_AllocatedSize_3`       BIGINT
  ,`DATA_RealSize_3`            BIGINT
  ,`DATA_InitializedStreamSize_3` BIGINT
  ,`STANDARD_INFORMATION_ON`    INTEGER  NOT NULL
  ,`ATTRIBUTE_LIST_ON`          INTEGER  NOT NULL
  ,`FILE_NAME_ON`               INTEGER  NOT NULL
  ,`OBJECT_ID_ON`               INTEGER  NOT NULL
  ,`SECURITY_DESCRIPTOR_ON`     INTEGER  NOT NULL
  ,`VOLUME_NAME_ON`             INTEGER  NOT NULL
  ,`VOLUME_INFORMATION_ON`      INTEGER  NOT NULL
  ,`DATA_ON`                    INTEGER  NOT NULL
  ,`INDEX_ROOT_ON`              INTEGER  NOT NULL
  ,`INDEX_ALLOCATION_ON`        INTEGER  NOT NULL
  ,`BITMAP_ON`                  INTEGER  NOT NULL
  ,`REPARSE_POINT_ON`           INTEGER  NOT NULL
  ,`EA_INFORMATION_ON`          INTEGER  NOT NULL
  ,`EA_ON`                      INTEGER  NOT NULL
  ,`PROPERTY_SET_ON`            INTEGER  NOT NULL
  ,`LOGGED_UTILITY_STREAM_ON`   INTEGER  NOT NULL
);
