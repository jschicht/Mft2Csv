LOAD DATA LOCAL INFILE "__PathToCsv__"
INTO TABLE MFT_OBJECTID
CHARACTER SET 'latin1'
COLUMNS TERMINATED BY '|'
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@MftRef, @MftRefSeqNo, `ObjectId`, @ObjectId_Version, @ObjectId_Timestamp, @ObjectId_TimestampDec, @ObjectId_ClockSeq, `ObjectId_Node`, `BirthVolumeId`, @BirthVolumeId_Version, @BirthVolumeId_Timestamp, @BirthVolumeId_TimestampDec, @BirthVolumeId_ClockSeq, `BirthVolumeId_Node`, `BirthObjectId`, @BirthObjectId_Version, @BirthObjectId_Timestamp, @BirthObjectId_TimestampDec, @BirthObjectId_ClockSeq, `BirthObjectId_Node`, `DomainId`, @DomainId_Version, @DomainId_Timestamp, @DomainId_TimestampDec, @DomainId_ClockSeq, `DomainId_Node`)
SET 
MftRef = nullif(@MftRef,''),
MftRefSeqNo = nullif(@MftRefSeqNo,''),
ObjectId_Version = nullif(@ObjectId_Version,''),
ObjectId_Timestamp = nullif(@ObjectId_Timestamp,''),
ObjectId_TimestampDec = nullif(@ObjectId_TimestampDec,''),
ObjectId_ClockSeq = nullif(@ObjectId_ClockSeq,''),
BirthVolumeId_Version = nullif(@BirthVolumeId_Version,''),
BirthVolumeId_Timestamp = nullif(@BirthVolumeId_Timestamp,''),
BirthVolumeId_TimestampDec = nullif(@BirthVolumeId_TimestampDec,''),
BirthVolumeId_ClockSeq = nullif(@BirthVolumeId_ClockSeq,''),
BirthObjectId_Version = nullif(@BirthObjectId_Version,''),
BirthObjectId_Timestamp = nullif(@BirthObjectId_Timestamp,''),
BirthObjectId_TimestampDec = nullif(@BirthObjectId_TimestampDec,''),
BirthObjectId_ClockSeq = nullif(@BirthObjectId_ClockSeq,''),
DomainId_Version = nullif(@DomainId_Version,''),
DomainId_Timestamp = nullif(@DomainId_Timestamp,''),
DomainId_TimestampDec = nullif(@DomainId_TimestampDec,''),
DomainId_ClockSeq = nullif(@DomainId_ClockSeq,'')
;