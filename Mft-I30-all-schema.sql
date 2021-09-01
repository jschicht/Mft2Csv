
CREATE TABLE MFT_I30(
	`Id`						INT(11) NOT NULL AUTO_INCREMENT
	,`Offset`					VARCHAR(18) NOT NULL
	,`fromSlack`				TINYINT(1)
	,`FileName`					VARCHAR(255) NOT NULL
	,`MFTReference`				BIGINT  NOT NULL
	,`MFTReferenceSeqNo`		BIGINT  NOT NULL
	,`IndexFlags`				INTEGER NOT NULL
	,`MFTParentReference`		BIGINT  NOT NULL
	,`MFTParentReferenceSeqNo`	BIGINT  NOT NULL
	,`CTime`					DATETIME(6)  NOT NULL
	,`ATime`					DATETIME(6)  NOT NULL
	,`MTime`					DATETIME(6)  NOT NULL
	,`RTime`					DATETIME(6)  NOT NULL
	,`AllocSize`                BIGINT  NOT NULL
	,`RealSize`					BIGINT  NOT NULL
	,`FileFlags`				VARCHAR(64) NOT NULL
	,`ReparseTag`				VARCHAR(32) NOT NULL
	,`EaSize`					INT(11) NOT NULL
	,`NameSpace`				VARCHAR(9) NOT NULL
	,`CorruptEntries`          VARCHAR(255) NULL DEFAULT NULL
	,PRIMARY KEY (Id)
);