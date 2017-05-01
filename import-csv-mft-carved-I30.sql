LOAD DATA LOCAL INFILE "__PathToCsv__"
INTO TABLE MFT_Carved_I30
CHARACTER SET 'latin1'
COLUMNS TERMINATED BY '|'
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Offset`, @MftRecordNumber, `FileName`, @MFTReference, @MFTReferenceSeqNo, @IndexFlags, @MFTParentReference, @MFTParentReferenceSeqNo, CTime, ATime, MTime, RTime, @AllocSize, @RealSize, `FileFlags`, `ReparseTag`, `NameSpace`, @`TextInformation`)
SET 
MftRecordNumber = nullif(@MftRecordNumber,''),
MFTReference = nullif(@MFTReference,''),
MFTReferenceSeqNo = nullif(@MFTReferenceSeqNo,''),
IndexFlags = nullif(@IndexFlags,''),
MFTParentReference = nullif(@MFTParentReference,''),
MFTParentReferenceSeqNo = nullif(@MFTParentReferenceSeqNo,''),
AllocSize = nullif(@AllocSize,''),
RealSize = nullif(@RealSize,''),
TextInformation = nullif(@TextInformation,'')
;