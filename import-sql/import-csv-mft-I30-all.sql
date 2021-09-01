LOAD DATA LOCAL INFILE "__PathToCsv__"
INTO TABLE MFT_I30
CHARACTER SET 'latin1'
COLUMNS TERMINATED BY '|'
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Offset`, @fromSlack, `FileName`, @MFTReference, @MFTReferenceSeqNo, @IndexFlags, @MFTParentReference, @MFTParentReferenceSeqNo, CTime, ATime, MTime, RTime, @AllocSize, @RealSize, `FileFlags`, `ReparseTag`, @EaSize, `NameSpace`, @`CorruptEntries`)
SET 
fromSlack = nullif(@fromSlack,''),
MFTReference = nullif(@MFTReference,''),
MFTReferenceSeqNo = nullif(@MFTReferenceSeqNo,''),
IndexFlags = nullif(@IndexFlags,''),
MFTParentReference = nullif(@MFTParentReference,''),
MFTParentReferenceSeqNo = nullif(@MFTParentReferenceSeqNo,''),
AllocSize = nullif(@AllocSize,''),
RealSize = nullif(@RealSize,''),
EaSize = nullif(@EaSize,''),
CorruptEntries = nullif(@CorruptEntries,'')
;