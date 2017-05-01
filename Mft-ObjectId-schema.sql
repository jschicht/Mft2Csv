
CREATE TABLE MFT_OBJECTID(
	`Id`							INT(11) NOT NULL AUTO_INCREMENT
	,`MftRef`						BIGINT  NOT NULL
	,`MftRefSeqNo`					SMALLINT(5)  NOT NULL
	,`ObjectId`						VARCHAR(38) NOT NULL
	,`ObjectId_Version`				TINYINT(2) NULL DEFAULT NULL
	,`ObjectId_Timestamp`			DATETIME(6)  NULL DEFAULT NULL
	,`ObjectId_TimestampDec`		BIGINT  NULL DEFAULT NULL
	,`ObjectId_ClockSeq`			SMALLINT(5) NULL DEFAULT NULL
	,`ObjectId_Node`				VARCHAR(17) NULL DEFAULT NULL
	,`BirthVolumeId`				VARCHAR(38) NOT NULL
	,`BirthVolumeId_Version`		TINYINT(2) NULL DEFAULT NULL
	,`BirthVolumeId_Timestamp`		DATETIME(6)  NULL DEFAULT NULL
	,`BirthVolumeId_TimestampDec`	BIGINT  NULL DEFAULT NULL
	,`BirthVolumeId_ClockSeq`		SMALLINT(5) NULL DEFAULT NULL
	,`BirthVolumeId_Node`			VARCHAR(17) NULL DEFAULT NULL
	,`BirthObjectId`				VARCHAR(38) NOT NULL
	,`BirthObjectId_Version`		TINYINT(2) NULL DEFAULT NULL
	,`BirthObjectId_Timestamp`		DATETIME(6)  NULL DEFAULT NULL
	,`BirthObjectId_TimestampDec`	BIGINT  NULL DEFAULT NULL
	,`BirthObjectId_ClockSeq`		SMALLINT(5) NULL DEFAULT NULL
	,`BirthObjectId_Node`			VARCHAR(17) NULL DEFAULT NULL
	,`DomainId`						VARCHAR(38) NOT NULL
	,`DomainId_Version`				TINYINT(2) NULL DEFAULT NULL
	,`DomainId_Timestamp`			DATETIME(6)  NULL DEFAULT NULL
	,`DomainId_TimestampDec`		BIGINT  NULL DEFAULT NULL
	,`DomainId_ClockSeq`			SMALLINT(5) NULL DEFAULT NULL
	,`DomainId_Node`				VARCHAR(17) NULL DEFAULT NULL
	,PRIMARY KEY (Id)
);