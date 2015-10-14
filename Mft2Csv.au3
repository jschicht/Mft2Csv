#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Program Files (x86)\autoit-v3.3.14.2\Icons\au3script_v9.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Decode $MFT and write to CSV
#AutoIt3Wrapper_Res_Description=Decode $MFT and write to CSV
#AutoIt3Wrapper_Res_Fileversion=2.0.0.33
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Include <WinAPIEx.au3>
#Include <File.au3>
#include <String.au3>
#include <Date.au3>
#include <array.au3>
; https://github.com/jschicht
;
; by Joakim Schicht & Ddan
; parts by trancexxx, Ascend4nt & others

Global $_COMMON_KERNEL32DLL=DllOpen("kernel32.dll"), $separator="|", $PrecisionSeparator=".", $PrecisionSeparator2="", $dol2t=False, $DoDefaultAll=False, $DoBodyfile=False, $SkipFixups=False, $MftIsBroken=False, $ExtractResident=False, $ExtractionPath, $DoSplitCsv=False, $csvextra, $style, $TimestampStart
Global $csv, $csvfile, $RecordOffset, $Signature, $ADS, $FN_NamePath, $UTCconfig, $de=",", $MftFileSize, $FN_FileName, $LogicalClusterNumberforthefileMFT, $ClustersPerFileRecordSegment, $MftAttrListString, $BytesPerSector, $SplitMftRecArr[1]
Global $HDR_LSN, $HDR_SequenceNo, $HDR_Flags, $HDR_RecRealSize, $HDR_RecAllocSize, $HDR_BaseRecord, $HDR_NextAttribID, $HDR_MFTREcordNumber, $HDR_HardLinkCount, $HDR_BaseRecSeqNo
Global $SI_CTime, $SI_ATime, $SI_MTime, $SI_RTime, $SI_FilePermission, $SI_USN, $Errors, $DT_AllocSize, $DT_RealSize, $DT_InitStreamSize, $RecordSlackSpace,$SI_Quota,$FN_EaSize,$FN_EaSize_2,$FN_EaSize_3
Global $SI_CTime_Core,$SI_ATime_Core,$SI_MTime_Core,$SI_RTime_Core,$SI_CTime_Precision,$SI_ATime_Precision,$SI_MTime_Precision,$SI_RTime_Precision
Global $FN_CTime, $FN_ATime, $FN_MTime, $FN_RTime, $FN_AllocSize, $FN_RealSize, $FN_Flags, $FN_Name, $DT_VCNs, $DT_NonResidentFlag, $FN_NameType
Global $FN_CTime_Core,$FN_ATime_Core,$FN_MTime_Core,$FN_RTime_Core,$FN_CTime_Precision,$FN_ATime_Precision,$FN_MTime_Precision,$FN_RTime_Precision
Global $FN_CTime_2, $FN_ATime_2, $FN_MTime_2, $FN_RTime_2, $FN_AllocSize_2, $FN_RealSize_2, $FN_Flags_2, $FN_NameLen_2, $FN_Name_2, $FN_NameType_2
Global $FN_CTime_2_Core,$FN_ATime_2_Core,$FN_MTime_2_Core,$FN_RTime_2_Core,$FN_CTime_2_Precision,$FN_ATime_2_Precision,$FN_MTime_2_Precision,$FN_RTime_2_Precision
Global $FN_CTime_3, $FN_ATime_3, $FN_MTime_3, $FN_RTime_3, $FN_AllocSize_3, $FN_RealSize_3, $FN_Flags_3, $FN_NameLen_3, $FN_Name_3, $FN_NameType_3
Global $FN_CTime_3_Core,$FN_ATime_3_Core,$FN_MTime_3_Core,$FN_RTime_3_Core,$FN_CTime_3_Precision,$FN_ATime_3_Precision,$FN_MTime_3_Precision,$FN_RTime_3_Precision
Global $DT_NameLength, $DT_NameRelativeOffset, $DT_Flags, $DT_NameSpace, $DT_Name, $RecordActive, $DT_ComprUnitSize, $DT_ComprUnitSize_2, $DT_ComprUnitSize_3
Global $DT_NonResidentFlag_2, $DT_NameLength_2, $DT_NameRelativeOffset_2, $DT_Flags_2, $DT_NameSpace_2, $DT_Name_2, $DT_StartVCN_2, $DT_LastVCN_2, $DT_VCNs_2, $DT_AllocSize_2, $DT_RealSize_2, $DT_InitStreamSize_2
Global $DT_NonResidentFlag_3, $DT_NameLength_3, $DT_NameRelativeOffset_3, $DT_Flags_3, $DT_NameSpace_3, $DT_Name_3, $DT_StartVCN_3, $DT_LastVCN_3, $DT_VCNs_3, $DT_AllocSize_3, $DT_RealSize_3, $DT_InitStreamSize_3
Global $FN_ParentRefNo, $FN_ParentSeqNo, $FN_ParentRefNo_2, $FN_ParentSeqNo_2, $FN_ParentRefNo_3, $FN_ParentSeqNo_3, $FN_ParentRefNo_4, $FN_ParentSeqNo_4, $RecordHealth
Global $DT_LengthOfAttribute, $DT_OffsetToAttribute, $DT_IndexedFlag, $DT_LengthOfAttribute_2, $DT_OffsetToAttribute_2, $DT_IndexedFlag_2, $DT_LengthOfAttribute_3, $DT_OffsetToAttribute_3, $DT_IndexedFlag_3
Global $hFile, $nBytes, $MSecTest, $CTimeTest, $SI_MaxVersions, $SI_VersionNumber, $SI_ClassID, $SI_OwnerID, $SI_SecurityID, $SI_HEADER_Flags, $SI_ON, $AL_ON, $FN_ON, $OI_ON, $SD_ON, $VN_ON, $VI_ON, $DT_ON, $IR_ON, $IA_ON, $BITMAP_ON, $RP_ON, $EAI_ON, $EA_ON, $PS_ON, $LUS_ON
Global $GUID_ObjectID, $GUID_BirthVolumeID, $GUID_BirthObjectID, $GUID_BirthDomainID, $VOLUME_NAME_NAME, $VOL_INFO_NTFS_VERSION, $VOL_INFO_FLAGS, $INV_FNAME, $INV_FNAME_2, $INV_FNAME_3, $DT_Number
Global $FileSizeBytes, $IntegrityCheck, $ComboPhysicalDrives, $IsPhysicalDrive=False,$GlobalRefCounter=0,$IsShadowCopy=False,$EncodingWhenOpen=2
;Global $TimestampErrorVal = "-"
Global $TimestampErrorVal = "0000-00-00 00:00:00"
;Global $TimestampErrorVal = "9999-12-31 00:00:00"
Global Const $RecordSignatureBad = '42414144' ; BAAD signature
Global Const $STANDARD_INFORMATION = '10000000'
Global Const $ATTRIBUTE_LIST = '20000000'
Global Const $FILE_NAME = '30000000'
Global Const $OBJECT_ID = '40000000'
Global Const $SECURITY_DESCRIPTOR = '50000000'
Global Const $VOLUME_NAME = '60000000'
Global Const $VOLUME_INFORMATION = '70000000'
Global Const $DATA = '80000000'
Global Const $INDEX_ROOT = '90000000'
Global Const $INDEX_ALLOCATION = 'A0000000'
Global Const $BITMAP = 'B0000000'
Global Const $REPARSE_POINT = 'C0000000'
Global Const $EA_INFORMATION = 'D0000000'
Global Const $EA = 'E0000000'
Global Const $PROPERTY_SET = 'F0000000'
Global Const $LOGGED_UTILITY_STREAM = '00010000'
Global Const $ATTRIBUTE_END_MARKER = 'FFFFFFFF'
Global Const $ATTRIB_HEADER_FLAG_COMPRESSED = 0x0001
Global Const $ATTRIB_HEADER_FLAG_ENCRYPTED = 0x4000
Global Const $ATTRIB_HEADER_FLAG_SPARSE = 0x8000
Global Const $SI_FILE_PERM_READ_ONLY = 0x0001
Global Const $SI_FILE_PERM_HIDDEN = 0x0002
Global Const $SI_FILE_PERM_SYSTEM = 0x0004
;Global Const $SI_FILE_PERM_DIRECTORY = 0x0010
Global Const $SI_FILE_PERM_ARCHIVE = 0x0020
Global Const $SI_FILE_PERM_DEVICE = 0x0040
Global Const $SI_FILE_PERM_NORMAL = 0x0080
Global Const $SI_FILE_PERM_TEMPORARY = 0x0100
Global Const $SI_FILE_PERM_SPARSE_FILE = 0x0200
Global Const $SI_FILE_PERM_REPARSE_POINT = 0x0400
Global Const $SI_FILE_PERM_COMPRESSED = 0x0800
Global Const $SI_FILE_PERM_OFFLINE = 0x1000
Global Const $SI_FILE_PERM_NOT_INDEXED = 0x2000
Global Const $SI_FILE_PERM_ENCRYPTED = 0x4000
;Global Const $SI_FILE_PERM_VIRTUAL = 0x10000
Global Const $SI_FILE_PERM_DIRECTORY = 0x10000000
Global Const $SI_FILE_PERM_INDEX_VIEW = 0x20000000
Global Const $FILE_RECORD_FLAG_FILE_DELETE = 0x0000
Global Const $FILE_RECORD_FLAG_FILE = 0x0001
Global Const $FILE_RECORD_FLAG_DIRECTORY = 0x0003
Global Const $FILE_RECORD_FLAG_DIRECTORY_DELETE = 0x0002
Global Const $FILE_RECORD_FLAG_UNKNOWN1 = 0x0004
Global Const $FILE_RECORD_FLAG_UNKNOWN2 = 0x0008
Global $DateTimeFormat,$ExampleTimestampVal = "01CD74B3150770B8",$TimestampPrecision
Global $tDelta = _WinTime_GetUTCToLocalFileTimeDelta()

Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $ES_AUTOVSCROLL = 64
Global Const $WS_VSCROLL = 0x00200000
Global Const $DT_END_ELLIPSIS = 0x8000
Global Const $GUI_DISABLE = 128

Global $TargetDrive = "", $MFT_Record_Size, $BytesPerCluster, $MFT_Offset, $MFT_Size
Global $FileTree[1], $hDisk, $rBuffer, $NonResidentFlag, $zPath, $sBuffer, $Total, $MFTTree[1]
Global $FN_Name, $ADS_Name, $Reparse = ""
Global $DT_LengthOfAttribute, $DT_Clusters, $DT_RealSize, $DT_InitSize, $DataRun
Global $IsCompressed, $IsSparse, $subset, $logfile = 0, $subst, $active = False
Global $RUN_VCN[1], $RUN_Clusters[1], $MFT_RUN_Clusters[1], $MFT_RUN_VCN[1], $DataQ[1], $AttrQ[1]
Global $TargetImageFile, $Entries, $IsImage = False, $ImageOffset=0, $IsMftFile=False, $TargetMftFile
Global $begin, $ElapsedTime,$InitState=1
Global $OverallProgress, $FileProgress, $CurrentProgress=-1, $ProgressStatus, $ProgressFileName, $ProgressSize

Global Const $RecordSignature = '46494C45' ; FILE signature

Global $myctredit, $CheckUnicode, $CheckCsvSplit, $checkFixups, $checkBrokenMFT, $checkl2t, $checkbodyfile, $checkdefaultall, $SeparatorInput, $checkquotes
$Progversion = "Mft2Csv 2.0.0.33"
If $cmdline[0] > 0 Then
	$CommandlineMode = 1
	ConsoleWrite($Progversion & @CRLF)
	$TimestampStart = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC
	$logfile = FileOpen(@ScriptDir & "\MftDump_" & $TimestampStart & ".log",2+32)
	_GetInputParams()
Else
	DllCall("kernel32.dll", "bool", "FreeConsole")
	$CommandlineMode = 0

	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

	$Form = GUICreate($Progversion, 560, 450, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_HandleExit", $Form)

	$Combo = GUICtrlCreateCombo("", 20, 30, 390, 20)
	$ComboPhysicalDrives = GUICtrlCreateCombo("", 180, 3, 305, 20)
	$buttonScanPhysicalDrives = GUICtrlCreateButton("Scan Physical", 5, 3, 80, 20)
	GUICtrlSetOnEvent($buttonScanPhysicalDrives, "_HandleEvent")
	$buttonScanShadowCopies = GUICtrlCreateButton("Scan Shadows", 90, 3, 80, 20)
	GUICtrlSetOnEvent($buttonScanShadowCopies, "_HandleEvent")
	$buttonTestPhysicalDrive = GUICtrlCreateButton("<-- Test it", 495, 3, 60, 20)
	GUICtrlSetOnEvent($buttonTestPhysicalDrive, "_HandleEvent")
	$buttonDrive = GUICtrlCreateButton("Rescan Mounted Drives", 425, 25, 130, 20)
	GUICtrlSetOnEvent($buttonDrive, "_HandleEvent")
	$checkFixups = GUICtrlCreateCheckbox("Skip Fixups", 335, 50, 95, 20)
	$checkBrokenMFT = GUICtrlCreateCheckbox("Broken $MFT", 335, 75, 95, 20)
	$checkExtractResident = GUICtrlCreateCheckbox("Extract Resident", 335, 100, 95, 20)
	$buttonImage = GUICtrlCreateButton("Choose Image", 440, 50, 100, 20)
	GUICtrlSetOnEvent($buttonImage, "_HandleEvent")
	$buttonMftFile = GUICtrlCreateButton("Choose $MFT", 440, 75, 100, 20)
	GUICtrlSetOnEvent($buttonMftFile, "_HandleEvent")
	;$buttonOutput = GUICtrlCreateButton("Choose CSV", 440, 100, 100, 20)
	;GUICtrlSetOnEvent($buttonOutput, "_HandleEvent")
	$buttonExtractedOut = GUICtrlCreateButton("Set Extract Path", 440, 100, 100, 20)
	GUICtrlSetOnEvent($buttonExtractedOut, "_HandleEvent")
	$buttonStart = GUICtrlCreateButton("Start Processing", 430, 125, 120, 40)
	GUICtrlSetOnEvent($buttonStart, "_HandleEvent")
	$Label1 = GUICtrlCreateLabel("Set decoded timestamps to specific region:",5,50,230,20)
	$Combo2 = GUICtrlCreateCombo("", 230, 50, 90, 25)
	GUICtrlCreateLabel("Set output format:",5,70,100,20)
	$checkl2t = GUICtrlCreateCheckbox("log2timeline", 120, 70, 130, 20)
	GUICtrlSetState($checkl2t, $GUI_UNCHECKED)
	$checkbodyfile = GUICtrlCreateCheckbox("bodyfile", 120, 90, 130, 20)
	GUICtrlSetState($checkbodyfile, $GUI_UNCHECKED)
	$checkdefaultall = GUICtrlCreateCheckbox("dump everything", 120, 110, 130, 20)
	GUICtrlSetState($checkdefaultall, $GUI_CHECKED)
	$LabelSeparator = GUICtrlCreateLabel("Set separator:",5,135,70,20)
	$SeparatorInput = GUICtrlCreateInput($separator,90,135,20,20)
	$SeparatorInput2 = GUICtrlCreateInput($separator,120,135,30,20)
	GUICtrlSetState($SeparatorInput2, $GUI_DISABLE)
	$checkquotes = GUICtrlCreateCheckbox("Quotation mark", 170, 135, 100, 20)
	GUICtrlSetState($checkquotes, $GUI_UNCHECKED)
	$CheckUnicode = GUICtrlCreateCheckbox("Unicode", 280, 135, 60, 20)
	GUICtrlSetState($CheckUnicode, $GUI_UNCHECKED)
	$CheckCsvSplit = GUICtrlCreateCheckbox("split csv", 350, 135, 60, 20)
	GUICtrlSetState($CheckCsvSplit, $GUI_UNCHECKED)

	$LabelTimestampFormat = GUICtrlCreateLabel("Timestamp format:",5,168,90,20)
	$ComboTimestampFormat = GUICtrlCreateCombo("", 110, 168, 30, 25)
	$LabelTimestampPrecision = GUICtrlCreateLabel("Precision:",150,168,50,20)
	$ComboTimestampPrecision = GUICtrlCreateCombo("", 200, 168, 70, 25)

	$LabelTimestampError = GUICtrlCreateLabel("Timestamp ErrorVal:",280,168,110,20)
	$TimestampErrorInput = GUICtrlCreateInput($TimestampErrorVal,380,168,130,20)

	$LabelPrecisionSeparator = GUICtrlCreateLabel("Precision separator:",5,190,100,20)
	$PrecisionSeparatorInput = GUICtrlCreateInput($PrecisionSeparator,110,190,15,20)
	$LabelPrecisionSeparator2 = GUICtrlCreateLabel("Precision separator2:",140,190,100,20)
	$PrecisionSeparatorInput2 = GUICtrlCreateInput($PrecisionSeparator2,250,190,15,20)

	$InputExampleTimestamp = GUICtrlCreateInput("",350,190,200,20)
	GUICtrlSetState($InputExampleTimestamp, $GUI_DISABLE)

	$myctredit = GUICtrlCreateEdit("Decoding $MFT" & @CRLF, 0, 215, 560, 65, BitAND($ES_AUTOVSCROLL,$WS_VSCROLL))
	_GetPhysicalDrives("PhysicalDrive")
	_GetMountedDrivesInfo()
	_InjectTimeZoneInfo()
	_InjectTimestampFormat()
	_InjectTimestampPrecision()
	_TranslateTimestamp()

	$LogState = True
	GUISetState(@SW_SHOW, $Form)

	While Not $active
	   Sleep(1000)	;Wait for event
	   _TranslateSeparator()
	   $PrecisionSeparator = GUICtrlRead($PrecisionSeparatorInput)
	   $PrecisionSeparator2 = GUICtrlRead($PrecisionSeparatorInput2)
	   _TranslateTimestamp()
	WEnd

	$tDelta = _GetUTCRegion(GUICtrlRead($Combo2))-$tDelta
	If @error Then
		_DisplayInfo("Error: Timezone configuration failed." & @CRLF)
	Else
		_DisplayInfo("Timestamps presented in UTC: " & $UTCconfig & @CRLF)
	EndIf
	$tDelta = $tDelta*-1 ;Since delta is substracted from timestamp later on

	$TimestampStart = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC
	$logfile = FileOpen(@ScriptDir & "\MftDump_" & $TimestampStart & ".log",2+32)
	$subset = 0

	Select
		Case $IsImage
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo),10),2)
			_DisplayInfo(@CRLF & "Target is: " & GUICtrlRead($Combo) & @CRLF)
			_DebugOut("Target image file: " & $TargetImageFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetImageFile,2,2,7)
			If $hDisk = 0 Then _DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
		Case $IsMftFile
			_DebugOut("Target $MFT file: " & $TargetMftFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetMftFile,2,2,7)
			If $hDisk = 0 Then _DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
			$MftFileSize = _WinAPI_GetFileSizeEx($hDisk)
		Case $IsPhysicalDrive=True
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo),10),2)
			_DebugOut("Target is: \\.\" & $TargetImageFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetImageFile,2,2,7)
			If $hDisk = 0 Then _DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
		Case $IsShadowCopy = True
			$TargetDrive = "SC"&StringMid($TargetImageFile,47)
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo),10),2)
			_DebugOut("Target drive is: " & $TargetImageFile)
			_DebugOut("Volume at offset: " & $ImageOffset)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetImageFile,2,2,7)
			If $hDisk = 0 Then _DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
		Case Else
	;	Case $IsPhysicalDrive=False
			$TargetDrive = StringMid(GUICtrlRead($Combo),1,2)
			_DebugOut("Target volume: " & $TargetDrive)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetDrive,2,2,7)
			If $hDisk = 0 Then _DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
	EndSelect

EndIf

_DebugOut("Timestamps presented in UTC " & $UTCconfig)
_DebugOut("Operation started: " & $TimestampStart)
$begin1 = TimerInit()
_ExtractSystemfile()
_DebugOut("Total processing time is " & _WinAPI_StrFromTimeInterval(TimerDiff($begin1)))
_WinAPI_CloseHandle($hDisk)
If $logfile Then FileClose($logfile)
$active = False
Exit

Func _HandleEvent()
	If Not $active Then
		Switch @GUI_CTRLID
			Case $buttonDrive
				_GetMountedDrivesInfo()
				$IsImage = False
				$IsShadowCopy = False
				$IsPhysicalDrive = False
			Case $buttonImage
				_ProcessImage()
				$IsImage = True
				$IsShadowCopy = False
				$IsPhysicalDrive = False
			Case $buttonMftFile
				_SelectMftFile()
				$IsMftFile = True
				$IsImage = False
				$MFT_Record_Size = InputBox("Set record size","$MFT record size (1024,4096)",1024)
;			Case $buttonOutput
;				_SelectCsv()
			Case $buttonStart
;				If $csv = "" Then
;					_DisplayInfo("Error: Output CSV not set " & @CRLF)
;					Return
;				EndIf
				If GUICtrlRead($checkExtractResident) = 1 Then
					$ExtractResident = True
					If $ExtractionPath="" Then
						_DisplayInfo("Error: No path selected for extracted resident data" & @CRLF)
						Return
					EndIf
					_DebugOut("Extracting resident data to: " & $ExtractionPath)
				EndIf
				$active = True
			Case $buttonExtractedOut
				_SetExtractionPath()
;				If $ExtractionPath="" Then Return
			Case $buttonScanPhysicalDrives
				_GetPhysicalDrives("PhysicalDrive")
				$IsShadowCopy = False
				$IsPhysicalDrive = True
				$IsImage = False
			Case $buttonScanShadowCopies
				_GetPhysicalDrives("GLOBALROOT\Device\HarddiskVolumeShadowCopy")
				$IsShadowCopy = True
				$IsPhysicalDrive = False
				$IsImage = False
			Case $buttonTestPhysicalDrive
				_TestPhysicalDrive()
		EndSwitch
	EndIf
EndFunc

Func _HandleExit()
   If $logfile Then FileClose($logfile)
   If $hDisk Then _WinAPI_CloseHandle($hDisk)
   Exit
EndFunc

Func _ExtractSystemfile()
	Local $nBytes
	Global $DataQ[1], $RUN_VCN[1], $RUN_Clusters[1]
	$TimestampStart = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC

	If $CommandlineMode Then
		$CheckUnicode = $CheckUnicode
	Else
		$CheckUnicode = GUICtrlRead($CheckUnicode)
	EndIf
	If $CheckUnicode = 1 Then
		$EncodingWhenOpen = 2+128
		_DebugOut("UNICODE configured")
	Else
		$EncodingWhenOpen = 2
		_DebugOut("ANSI configured")
	EndIf

	_SelectCsv()

	If Not $CommandlineMode Then
		$TimestampErrorVal = GUICtrlRead($TimestampErrorInput)
	Else
		$TimestampErrorVal = $TimestampErrorVal
	EndIf

	If $CommandlineMode Then
		$PrecisionSeparator = $PrecisionSeparator
		$PrecisionSeparator2 = $PrecisionSeparator2
	Else
		$PrecisionSeparator = GUICtrlRead($PrecisionSeparatorInput)
		$PrecisionSeparator2 = GUICtrlRead($PrecisionSeparatorInput2)
	EndIf
	If StringLen($PrecisionSeparator) <> 1 Then
		If Not $CommandlineMode Then _DisplayInfo("Error: Precision separator not set properly" & @crlf)
		_DebugOut("Error: Precision separator not set properly: " & $PrecisionSeparator)
		Return
	Else
		_DebugOut("Using precision separator: " & $PrecisionSeparator)
	EndIf

	If Not $CommandlineMode Then _TranslateTimestamp()

	If Not $CommandlineMode Then
		If Int(GUICtrlRead($checkl2t) + GUICtrlRead($checkbodyfile) + GUICtrlRead($checkdefaultall)) <> 9 Then
			_DebugOut("Error: Output format can only be one of the options (not more than 1).")
			Return
		EndIf
	EndIf

	If $CommandlineMode Then
		$CheckCsvSplit = $CheckCsvSplit
	Else
		$CheckCsvSplit = GUICtrlRead($CheckCsvSplit)
	EndIf
	If $CheckCsvSplit = 1 Then
		$DoSplitCsv = True
		_DebugOut("Splitting csv")
	EndIf

	If $CommandlineMode Then
		$checkFixups = $checkFixups
	Else
		$checkFixups = GUICtrlRead($checkFixups)
	EndIf
	If $checkFixups = 1 Then
		$SkipFixups = True
		_DebugOut("Skipping Fixups")
	EndIf

	If $CommandlineMode Then
		$checkBrokenMFT = $checkBrokenMFT
	Else
		$checkBrokenMFT = GUICtrlRead($checkBrokenMFT)
	EndIf
	If $checkBrokenMFT = 1 Then
		$MftIsBroken = True
		_DebugOut("Handling broken $MFT")
	EndIf

	If $CommandlineMode Then
		$checkl2t = $checkl2t
		$checkbodyfile = $checkbodyfile
		$checkdefaultall = $checkdefaultall
	Else
		$checkl2t = GUICtrlRead($checkl2t)
		$checkbodyfile = GUICtrlRead($checkbodyfile)
		$checkdefaultall = GUICtrlRead($checkdefaultall)
	EndIf
	If $checkl2t = 1 Then
		$Dol2t = True
		_DebugOut("Using output format: log2timeline")
	ElseIf $checkbodyfile = 1 Then
		$DoBodyfile = True
		_DebugOut("Using output format: bodyfile")
	ElseIf $checkdefaultall = 1 Then
		$DoDefaultAll = True
		_DebugOut("Using output format: all")
	EndIf

	If $CommandlineMode Then
		$SeparatorInput = $SeparatorInput
	Else
		$SeparatorInput = GUICtrlRead($SeparatorInput)
	EndIf
	If StringLen($SeparatorInput) <> 1 Then
		If Not $CommandlineMode Then _DisplayInfo("Error: Separator not set properly" & @crlf)
		_DebugOut("Error: Separator not set properly: " & $SeparatorInput)
		Return
	Else
		$de = $SeparatorInput
		_DebugOut("Using separator: " & $de)
	EndIf

	If $CommandlineMode Then
		$checkquotes = $checkquotes
	Else
		$checkquotes = GUICtrlRead($checkquotes)
	EndIf
	If $checkquotes = 1 Then
		_DebugOut("Writing variables surrounded with qoutes")
	Else
		_DebugOut("Writing variables without surrounding qoutes")
	EndIf

	_WriteCSVHeader()
	If $DoSplitCsv Then _WriteCSVExtraHeader()
	If (Not $IsImage and Not $IsMftFile and Not $IsShadowCopy) Then
		If DriveGetFileSystem($TargetDrive) <> "NTFS" Then		;read boot sector and extract $MFT data
			If Not $CommandlineMode Then _DisplayInfo("Error: Target volume " & $TargetDrive & " is not NTFS" & @crlf)
			Return
		EndIf
		If Not $CommandlineMode Then _DisplayInfo("Target volume is: " & $TargetDrive & @crlf)
	EndIf

	$MftSqlFile = @ScriptDir & "\MftDump_"&$TimestampStart&".sql"
	FileInstall("C:\temp\import-csv-mft.sql", $MftSqlFile)
	$FixedPath = StringReplace($csvfile,"\","\\")
	Sleep(500)
	_ReplaceStringInFile($MftSqlFile,"__PathToCsv__",$FixedPath)
	If $CheckUnicode = 1 Then _ReplaceStringInFile($MftSqlFile,"latin1", "utf8")

	If Not $IsMftFile Then _WinAPI_SetFilePointerEx($hDisk, $ImageOffset, $FILE_BEGIN)
	$BootRecord = _GetDiskConstants()
	If $BootRecord = "" Then
		_DebugOut("Unable to read Boot Sector")
		Return
	EndIf
	$rBuffer = DllStructCreate("byte[" & $MFT_Record_Size & "]")     ;buffer for records

	$MFT = _ReadMFT()
	If $MFT = "" And Not $MftIsBroken Then Return		;something wrong with record for $MFT

	$MFT = _DecodeMFTRecord0($MFT, 0)        ;produces DataQ for $MFT, record 0
	If $MFT = "" And Not $MftIsBroken Then Return

	_GetRunsFromAttributeListMFT0() ;produces datarun for $MFT and converts datarun to RUN_VCN[] and RUN_Clusters[]

	$MFT_Size = $DT_RealSize

	If ($IsMftFile And $MftIsBroken) Then
		$RUN_VCN[1] = 1
		$RUN_Clusters[1] = Int(((512+$MftFileSize-Mod($MftFileSize,512))/512/8))
	EndIf
	$MFT_RUN_VCN = $RUN_VCN
	$MFT_RUN_Clusters = $RUN_Clusters	;preserve values for $MFT

	$Progress = GUICtrlCreateLabel("Decoding $MFT info and writing to csv", 10, 280,540,20)
	GUICtrlSetFont($Progress, 12)
	$ProgressStatus = GUICtrlCreateLabel("", 10, 310, 540, 20)
	$ElapsedTime = GUICtrlCreateLabel("", 10, 325, 540, 20)
	$OverallProgress = GUICtrlCreateProgress(10, 350, 540, 30)
	If Not $MftIsBroken Then
		_DoFileTree()                        ;creates folder structure
	Else
		$Total = ($MftFileSize/$MFT_Record_Size)
		Redim $FileTree[$Total]
	EndIf

	$ProgressFileName = GUICtrlCreateLabel("", 10,  390, 540, 20, $DT_END_ELLIPSIS)
	$FileProgress = GUICtrlCreateProgress(10, 415, 540, 30)
	AdlibRegister("_ExtractionProgress", 500)
	$begin = TimerInit()
	For $i = 0 To UBound($FileTree)-1	;note $i is mft reference number
		$CurrentProgress = $i
		$Files = $Filetree[$i]
		If StringInStr($Files, "/") > 0 Then ;MFT record was split across 2 dataruns
			_DebugOut("Ref " & $i & " has its record split across 2 dataruns")
			$SplitRecordPart1 = StringMid($Files, StringInStr($Files, "/")+1)
			$SplitRecordPart2 = $SplitMftRecArr[$SplitRecordPart1]
			$SplitRecordTestRef = StringMid($SplitRecordPart2, 1, StringInStr($SplitRecordPart2, "?")-1)
			If $SplitRecordTestRef <> $i Then ;then something is not quite right
				_DebugOut("Error: The ref in the array did not match target ref.")
				ContinueLoop
			EndIf
			$SplitRecordPart3 = StringMid($SplitRecordPart2, StringInStr($SplitRecordPart2, "?")+1)
			$SplitRecordArr = StringSplit($SplitRecordPart3,"|")
			If UBound($SplitRecordArr) <> 3 Then
				_DebugOut("Error: Array contained more elements than expected: " & UBound($SplitRecordArr))
				ContinueLoop
			EndIf
			$MFTEntry="0x"
			For $k = 1 To Ubound($SplitRecordArr)-1
				$SplitRecordOffset = StringMid($SplitRecordArr[$k], 1, StringInStr($SplitRecordArr[$k], ",")-1)
				$SplitRecordSize = StringMid($SplitRecordArr[$k], StringInStr($SplitRecordArr[$k], ",")+1)
				_WinAPI_SetFilePointerEx($hDisk, $ImageOffset+$SplitRecordOffset, $FILE_BEGIN)
				$kBuffer = DllStructCreate("byte["&$SplitRecordSize&"]")
				_WinAPI_ReadFile($hDisk, DllStructGetPtr($kBuffer), $SplitRecordSize, $nBytes)
				$MFTEntry &= StringMid(DllStructGetData($kBuffer,1),3)
				$RecordOffsetDec = $SplitRecordOffset
				_DebugOut("	part " & $k & " of record has " & $SplitRecordSize & " bytes at raw offset 0x" & Hex(Int($ImageOffset+$SplitRecordOffset)))
				$kBuffer=0
			Next
;			ConsoleWrite(_HexEncode($MFTEntry) & @CRLF)
		Else
			If $IsMftFile Then
				_WinAPI_SetFilePointerEx($hDisk, $i*$MFT_Record_Size, $FILE_BEGIN)
				$RecordOffsetDec = $MFT_Record_Size * $i
			Else
				_WinAPI_SetFilePointerEx($hDisk, $MFTTree[$i], $FILE_BEGIN)
				$RecordOffsetDec = $MFTTree[$i]
			EndIf
			$RecordOffsetDec = Int($RecordOffsetDec)
			_WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $MFT_Record_Size, $nBytes)
			$MFTEntry = DllStructGetData($rBuffer, 1)
		EndIf
		$FN_NamePath = StringMid($Files, 1,StringInStr($Files, "?") - 1)
		$FN_FileName = $FN_NamePath
		If (StringMid($MFTEntry, 3, 8) = '46494C45') Then
			$Signature = "GOOD"
		ElseIf (StringMid($MFTEntry, 3, 8) = '42414144') Then
			$Signature = "BAAD"
		ElseIf (StringMid($MFTEntry, 3, 8) = '00000000') Then
			_ClearVar()
			$Signature = "ZERO"
			$RecordOffset = "0x" & Hex($RecordOffsetDec)
			If $DoDefaultAll Then
				If $checkquotes = 1 Then
					_WriteCSVwithQuotes()
					If $DoSplitCsv Then _WriteCSVExtraWithQuotes()
				Else
					_WriteCSV()
					If $DoSplitCsv Then _WriteCSVExtra()
				Endif
			Else
				If $checkquotes = 1 Then
					_WriteCSV2withQuotes()
				Else
					_WriteCSV2()
				EndIf
			EndIf
			$Signature = ""
			ContinueLoop
		Else
			_ClearVar()
			$Signature = "UNKNOWN"
			$RecordOffset = "0x" & Hex($RecordOffsetDec)
			If $DoDefaultAll Then
				If $checkquotes = 1 Then
					_WriteCSVwithQuotes()
					If $DoSplitCsv Then _WriteCSVExtraWithQuotes()
				Else
					_WriteCSV()
					If $DoSplitCsv Then _WriteCSVExtra()
				Endif
			Else
				If $checkquotes = 1 Then
					_WriteCSV2withQuotes()
				Else
					_WriteCSV2()
				EndIf
			EndIf
			$Signature = ""
			ContinueLoop
		EndIf
		If $ExtractResident Then
			_ExtractSingleFile($MFTEntry, $i)
		EndIf
		_ClearVar()
		_ParserCodeOldVersion($MFTEntry)
		If $DT_Number > 0 Then $ADS = $DT_Number - 1
		$RecordOffset = "0x" & Hex($RecordOffsetDec)
		$CTimeTest = _Test_SI2FN_CTime($SI_CTime, $FN_CTime)
		If $DoDefaultAll Then
			If $checkquotes = 1 Then
				_WriteCSVwithQuotes()
				If $DoSplitCsv Then _WriteCSVExtraWithQuotes()
			Else
				_WriteCSV()
				If $DoSplitCsv Then _WriteCSVExtra()
			Endif
		Else
			If $checkquotes = 1 Then
				_WriteCSV2withQuotes()
			Else
				_WriteCSV2()
			EndIf
		EndIf
		$Signature = ""
		If Not Mod($i,50000) Then
			FileFlush($csv)
		EndIf
	Next
	_WinAPI_CloseHandle($hDisk)
	AdlibUnRegister()
	GUIDelete($Progress)
	If Not $CommandlineMode Then _DisplayInfo("Finished processing " & $Total & " records" & @crlf)
	_DebugOut("Finished processing " & $Total & " records.")
EndFunc

Func _DoFileTree()
	Local $nBytes, $ParentRef, $FileRef, $BaseRef, $tag, $PrintName, $testvar=0, $TmpRecord, $MFTClustersToKeep=0, $DoKeepCluster=0, $Subtr, $PartOfAttrList=0, $ArrSize
	$Total = Int($MFT_Size/$MFT_Record_Size)
	Global $FileTree[$Total+1]
	Global $MFTTree[$Total+1]
	$ref = -1
	$Pos=0
	if $IsMftFile Then _WinAPI_SetFilePointerEx($hDisk, $Pos, $FILE_BEGIN)
	AdlibRegister("_DoFileTreeProgress", 500)
	$begin = TimerInit()
	For $r = 1 To Ubound($MFT_RUN_VCN)-1
		$DoKeepCluster=$MFTClustersToKeep
		$MFTClustersToKeep = Mod($MFT_RUN_Clusters[$r]+($ClustersPerFileRecordSegment-$MFTClustersToKeep),$ClustersPerFileRecordSegment)
		If $MFTClustersToKeep <> 0 Then
			$MFTClustersToKeep = $ClustersPerFileRecordSegment - $MFTClustersToKeep ;How many clusters are we missing to get the full MFT record
		EndIf
		If Not $IsMftFile Then
			$Pos = $MFT_RUN_VCN[$r]*$BytesPerCluster
			_WinAPI_SetFilePointerEx($hDisk, $ImageOffset+$Pos, $FILE_BEGIN)
		Else
			$Pos = $testvar*$MFT_Record_Size
		EndIf
		If $MFTClustersToKeep Or $DoKeepCluster Then
			$Subtr = 0
		Else
			$Subtr = $MFT_Record_Size
		EndIf
		$EndOfRun = $MFT_RUN_Clusters[$r]*$BytesPerCluster-$Subtr
		For $i = 0 To $MFT_RUN_Clusters[$r]*$BytesPerCluster-$Subtr Step $MFT_Record_Size
			If $MFTClustersToKeep Then
				If $i >= $EndOfRun-(($ClustersPerFileRecordSegment-$MFTClustersToKeep)*$BytesPerCluster) Then
					$BytesToGet = ($ClustersPerFileRecordSegment-$MFTClustersToKeep)*$BytesPerCluster
					$CurrentOffset = DllCall('kernel32.dll', 'int', 'SetFilePointerEx', 'ptr', $hDisk, 'int64', 0, 'int64*', 0, 'dword', 1)
					_WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $BytesToGet, $nBytes)
					$TmpRecord = StringMid(DllStructGetData($rBuffer, 1),1, 2+($BytesToGet*2))
					$ArrSize = UBound($SplitMftRecArr)
					ReDim $SplitMftRecArr[$ArrSize+1]
					$SplitMftRecArr[$ArrSize] = $ref+1 & '?' & $CurrentOffset[3] & ',' & $BytesToGet
					ContinueLoop
				EndIf
			EndIf
			$ref += 1
			If $ref > $Total Then ExitLoop
			$testvar += 1
			$CurrentProgress = $ref
			If $i = 0 And $DoKeepCluster Then
				If $TmpRecord <> "" Then $record = $TmpRecord
				$BytesToGet = $DoKeepCluster*$BytesPerCluster
				if $BytesToGet > $MFT_Record_Size Then
					MsgBox(0,"Error","$BytesToGet > $MFT_Record_Size")
					$BytesToGet = $MFT_Record_Size
				EndIf
				$CurrentOffset = DllCall('kernel32.dll', 'int', 'SetFilePointerEx', 'ptr', $hDisk, 'int64', 0, 'int64*', 0, 'dword', 1)
				_WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $BytesToGet, $nBytes)
				$record &= StringMid(DllStructGetData($rBuffer, 1),3, $BytesToGet*2)
				$TmpRecord=""
				$SplitMftRecArr[$ArrSize] &= '|' & $CurrentOffset[3] & ',' & $BytesToGet
			Else
				_WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $MFT_Record_Size, $nBytes)
				$record = DllStructGetData($rBuffer, 1)
			EndIf
			If StringMid($record,3,8) <> $RecordSignature Then
				_DebugOut($ref & " The record signature is bad", StringMid($record, 1, 34))
				ContinueLoop
			EndIf
			$CurrentMFTOffset = DllCall('kernel32.dll', 'int', 'SetFilePointerEx', 'ptr', $hDisk, 'int64', 0, 'int64*', 0, 'dword', 1)
			$MFTTree[$ref] = $CurrentMFTOffset[3]-$MFT_Record_Size
			$Flags = Dec(StringMid($record,47,4))
			If Not $SkipFixups Then $record = _DoFixup($record, $ref)
			If $record = "" then ContinueLoop   ;corrupt, failed fixup
			$FileRef = $ref
			$BaseRef = Dec(_SwapEndian(StringMid($record,67,8)),2)
			If $BaseRef <> 0 Or StringInStr($MftAttrListString,','&$FileRef&',') Then ;The baseRef can be 0 for the extra records when $MFT contains $ATTRIBUTE_LIST
				_DebugOut("Ref " & $FileRef & " has baseref " & $BaseRef)
				$FileTree[$FileRef] = $Pos + $i      ;may contain data attribute
				$FileRef = $BaseRef
				$PartOfAttrList=1
			Else
				$PartOfAttrList=0
			EndIf
			$Offset = (Dec(StringMid($record,43,2))*2)+3
			$FileName = ""
			While 1     ;only want names and reparse
				$Type = Dec(StringMid($record,$Offset,8),2)
				If $Type > Dec("C0000000",2) Then ExitLoop   ;no more names or reparse
				$Size = Dec(_SwapEndian(StringMid($record,$Offset+8,8)),2)
				If $Type = Dec("30000000",2) Then
					$attr = StringMid($record,$Offset,$Size*2)
					$ParentRef = Dec(_SwapEndian(StringMid($attr,49,8)),2)
					$NameSpace = StringMid($attr,179,2)
					If $NameSpace <> "02" Then
						$NameLength = Dec(StringMid($attr,177,2))
						$FileName = StringMid($attr,181,$NameLength*4)
						$FileName = BinaryToString("0x"&$FileName,2)
						If Not BitAND($Flags,Dec("0100")) Then $FileName = "[DEL" & $ref & "]" & $FileName     ;deleted record
						$FileTree[$FileRef] &= "**" & $ParentRef & "*" & $FileName
					EndIf
				ElseIf $Type = Dec("C0000000",2) Then
					$tag = StringMid($record,$Offset + 48,8)
					$PrintNameOffset = Dec(_SwapEndian(StringMid($record,$Offset+72,4)),2)
					$PrintNameLength = Dec(_SwapEndian(StringMid($record,$Offset+76,4)),2)
					If $tag = "030000A0" Then	;JUNCTION
						$PrintName = BinaryToString("0x"&StringMid($record, $Offset+80+$PrintNameOffset*2, $PrintNameLength*2),2)
					ElseIf $tag = "0C0000A0" Then	;SYMLINKD
						$PrintName = BinaryToString("0x"&StringMid($record, $Offset+80+$PrintNameOffset*2+8, $PrintNameLength*2),2)
					Else
						_DebugOut($ref & " Unhandled Reparse Tag: " & $tag, $record)
					EndIf
					$Reparse &= $ref & "*" & $tag & "*" & $PrintName & "?"
				EndIf
				$Offset += $Size*2
			WEnd
			If Not BitAND($Flags,Dec("0200")) And $PartOfAttrList=0 And $FileTree[$FileRef] <> "" Then $FileTree[$FileRef] &= "?" & ($Pos + $i)     ;file also add FilePointer
			If StringInStr($FileTree[$FileRef], "**") = 1 Then $FileTree[$FileRef] = StringTrimLeft($FileTree[$FileRef],2)    ;remove leading **
			If $i = 0 And $DoKeepCluster Then $FileTree[$FileRef] &= "/" & $ArrSize  ;Mark record as being split across 2 runs
		Next
	Next
	AdlibUnRegister()
	$FileTree[5] = ":"
	$begin = TimerInit()
	AdlibRegister("_FolderStrucProgress", 500)
	For $i = 0 to UBound($FileTree)-1
		$CurrentProgress = $i
		If StringInStr($FileTree[$i], "**") = 0 Then
			While StringInStr($FileTree[$i], "*") > 0   ;single file
				$Parent=StringMid($Filetree[$i], 1, StringInStr($FileTree[$i], "*")-1)
				If StringInStr($Filetree[$Parent],"?")=0 And (StringInStr($Filetree[$Parent],"*")>0 Or StringInStr($Filetree[$Parent],":")>0) Then
					$FileTree[$i] = StringReplace($FileTree[$i], $Parent & "*", $Filetree[$Parent] & "\")
				Else
					$FileTree[$i] = StringReplace($FileTree[$i], $Parent & "*", $Filetree[5] & "\ORPHAN\")
				EndIf
			WEnd
		Else
			$Names = StringSplit($FileTree[$i], "**",3)     ;hard links
			$str = ""
			For $n = 0 to UBound($Names) - 1
				While StringInStr($Names[$n], "*") > 0
					$Parent=StringMid($Names[$n], 1, StringInStr($Names[$n], "*")-1)
					If StringInStr($Filetree[$Parent],"?")=0 And (StringInStr($Filetree[$Parent],"*")>0 Or StringInStr($Filetree[$Parent],":")>0) Then
						$Names[$n] = StringReplace($Names[$n], $Parent & "*", $Filetree[$Parent] & "\")
					Else
						$Names[$n] = StringReplace($Names[$n], $Parent & "*", $Filetree[5] & "\ORPHAN\")
					EndIf
				WEnd
				$str &= $Names[$n] & "*"
			Next
			$FileTree[$i] = StringTrimRight($str,1)
		EndIf
	Next
	$FileTree[5] &= "\"
	AdlibUnRegister()
EndFunc

Func _DecodeAttrList($FileRef, $AttrList)
   Local $offset, $length, $nBytes, $List = "", $str = ""
   If StringMid($AttrList, 17, 2) = "00" Then		;attribute list is resident in AttrList
	  $offset = Dec(_SwapEndian(StringMid($AttrList, 41, 4)))
	  $List = StringMid($AttrList, $offset*2+1)		;gets list when resident
   Else			;attribute list is found from data run in $AttrList
	  $size = Dec(_SwapEndian(StringMid($AttrList, $offset*2 + 97, 16)))
	  $offset = ($offset + Dec(_SwapEndian(StringMid($AttrList, $offset*2 + 65, 4))))*2
	  $DataRun = StringMid($AttrList, $offset+1, StringLen($AttrList)-$offset)
	  Global $RUN_VCN[1], $RUN_Clusters[1]		;redim arrays
	  _ExtractDataRuns()
	  $cBuffer = DllStructCreate("byte[" & $BytesPerCluster & "]")
	  For $r = 1 To Ubound($RUN_VCN)-1
		 _WinAPI_SetFilePointerEx($hDisk, $ImageOffset+$RUN_VCN[$r]*$BytesPerCluster, $FILE_BEGIN)
		 For $i = 1 To $RUN_Clusters[$r]
			_WinAPI_ReadFile($hDisk, DllStructGetPtr($cBuffer), $BytesPerCluster, $nBytes)
			$List &= StringTrimLeft(DllStructGetData($cBuffer, 1),2)
		 Next
	  Next
	  $List = StringMid($List, 1, $size*2)
   EndIf
   If StringMid($List, 1, 8) <> "10000000" Then Return ""		;bad signature
   $offset = 0
   While StringLen($list) > $offset*2
	  $ref = Dec(_SwapEndian(StringMid($List, $offset*2 + 33, 8)))
	  If $ref <> $FileRef Then		;new attribute
		 If Not StringInStr($str, $ref) Then $str &= $ref & "-"
	  EndIf
	  $offset += Dec(_SwapEndian(StringMid($List, $offset*2 + 9, 4)))
   WEnd
   $AttrQ[0] = ""
   If $str <> "" Then $AttrQ = StringSplit(StringTrimRight($str,1), "-")
   Return $List
EndFunc

Func _StripMftRecord($record, $FileRef)
   If Not $SkipFixups Then $record = _DoFixup($record, $FileRef)
   If $record = "" then Return ""  ;corrupt, failed fixup
   $RecordSize = Dec(_SwapEndian(StringMid($record,51,8)),2)
   $HeaderSize = Dec(_SwapEndian(StringMid($record,43,4)),2)
   $record = StringMid($record,$HeaderSize*2+3,($RecordSize-$HeaderSize-8)*2)        ;strip "0x..." and "FFFFFFFF..."
   Return $record
EndFunc

Func _ExtractDataRuns()
   $r=UBound($RUN_Clusters)
   ReDim $RUN_Clusters[$r + $MFT_Record_Size], $RUN_VCN[$r + $MFT_Record_Size]
   $i=1
   $RUN_VCN[0] = 0
   $BaseVCN = $RUN_VCN[0]
   If $DataRun = "" Then $DataRun = "00"
   Do
	  $RunListID = StringMid($DataRun,$i,2)
	  If $RunListID = "00" Then ExitLoop
	  $i += 2
	  $RunListClustersLength = Dec(StringMid($RunListID,2,1))
	  $RunListVCNLength = Dec(StringMid($RunListID,1,1))
	  $RunListClusters = Dec(_SwapEndian(StringMid($DataRun,$i,$RunListClustersLength*2)),2)
	  $i += $RunListClustersLength*2
	  $RunListVCN = _SwapEndian(StringMid($DataRun, $i, $RunListVCNLength*2))
	  ;next line handles positive or negative move
	  $BaseVCN += Dec($RunListVCN,2)-(($r>1) And (Dec(StringMid($RunListVCN,1,1))>7))*Dec(StringMid("10000000000000000",1,$RunListVCNLength*2+1),2)
	  If $RunListVCN <> "" Then
		 $RunListVCN = $BaseVCN
	  Else
		 $RunListVCN = 0
	  EndIf
	  If (($RunListVCN=0) And ($RunListClusters>16) And (Mod($RunListClusters,16)>0)) Then
		 ;may be sparse section at end of Compression Signature
		 $RUN_Clusters[$r] = Mod($RunListClusters,16)
		 $RUN_VCN[$r] = $RunListVCN
		 $RunListClusters -= Mod($RunListClusters,16)
		 $r += 1
	  ElseIf (($RunListClusters>16) And (Mod($RunListClusters,16)>0)) Then
		 ;may be compressed data section at start of Compression Signature
		 $RUN_Clusters[$r] = $RunListClusters-Mod($RunListClusters,16)
		 $RUN_VCN[$r] = $RunListVCN
		 $RunListVCN += $RUN_Clusters[$r]
		 $RunListClusters = Mod($RunListClusters,16)
		 $r += 1
	  EndIf
	  ;just normal or sparse data
	  $RUN_Clusters[$r] = $RunListClusters
	  $RUN_VCN[$r] = $RunListVCN
	  $r += 1
	  $i += $RunListVCNLength*2
   Until $i > StringLen($DataRun)
   ReDim $RUN_Clusters[$r], $RUN_VCN[$r]
EndFunc

Func _DecodeDataQEntry($attr)		;processes data attribute
   $NonResidentFlag = StringMid($attr,17,2)
   $NameLength = Dec(StringMid($attr,19,2))
   $NameOffset = Dec(_SwapEndian(StringMid($attr,21,4)))
   If $NameLength > 0 Then		;must be ADS
	  $ADS_Name = BinaryToString("0x"&StringMid($attr,$NameOffset*2 + 1,$NameLength*4),2)
	  $ADS_Name = $FN_Name & "[ADS_" & $ADS_Name & "]"
   Else
	  $ADS_Name = $FN_Name		;need to preserve $FN_Name
   EndIf
   $Flags = StringMid($attr,25,4)
   If BitAND($Flags,"0100") Then $IsCompressed = 1
   If BitAND($Flags,"0080") Then $IsSparse = 1
   If $NonResidentFlag = '01' Then
	  $DT_Clusters = Dec(_SwapEndian(StringMid($attr,49,16)),2) - Dec(_SwapEndian(StringMid($attr,33,16)),2) + 1
	  $DT_RealSize = Dec(_SwapEndian(StringMid($attr,97,16)),2)
	  $DT_InitSize = Dec(_SwapEndian(StringMid($attr,113,16)),2)
	  $Offset = Dec(_SwapEndian(StringMid($attr,65,4)))
	  $DataRun = StringMid($attr,$Offset*2+1,(StringLen($attr)-$Offset)*2)
   ElseIf $NonResidentFlag = '00' Then
	  $DT_LengthOfAttribute = Dec(_SwapEndian(StringMid($attr,33,8)),2)
	  $Offset = Dec(_SwapEndian(StringMid($attr,41,4)))
	  $DataRun = StringMid($attr,$Offset*2+1,$DT_LengthOfAttribute*2)
  EndIf
EndFunc

Func _DecodeMFTRecord0($record, $FileRef)      ;produces DataQ
	$MftAttrListString=","
	If Not $SkipFixups Then $record = _DoFixup($record, $FileRef)
	If $record = "" then Return ""  ;corrupt, failed fixup
	$RecordSize = Dec(_SwapEndian(StringMid($record,51,8)),2)
	$AttributeOffset = (Dec(StringMid($record,43,2))*2)+3
	While 1		;only want Attribute List and Data Attributes
		$Type = Dec(_SwapEndian(StringMid($record,$AttributeOffset,8)),2)
		If $Type > 256 Then ExitLoop		;attributes may not be in numerical order
		$AttributeSize = Dec(_SwapEndian(StringMid($record,$AttributeOffset+8,8)),2)
		If $Type = 32 Then
			$AttrList = StringMid($record,$AttributeOffset,$AttributeSize*2)	;whole attribute
			$AttrList = _DecodeAttrList($FileRef, $AttrList)		;produces $AttrQ - extra record list
			If $AttrList = "" Then
				_DebugOut($FileRef & " Bad Attribute List signature", $record)
				Return ""
			Else
				If $AttrQ[0] = "" Then ContinueLoop		;no new records
				$str = ""
				For $i = 1 To $AttrQ[0]
					$MftAttrListString &= $AttrQ[$i] & ","
					If Not IsNumber(Int($AttrQ[$i])) Then
						_DebugOut($FileRef & " Overwritten extra record (" & $AttrQ[$i] & ")", $record)
						Return ""
					EndIf
					$rec = _GetAttrListMFTRecord(($AttrQ[$i]*$MFT_Record_Size)+($LogicalClusterNumberforthefileMFT*$BytesPerCluster))
					If StringMid($rec,3,8) <> $RecordSignature Then
						_DebugOut($FileRef & " Bad signature for extra record", $record)
						Return ""
					EndIf
					If Dec(_SwapEndian(StringMid($rec,67,8)),2) <> $FileRef Then
						_DebugOut($FileRef & " Bad extra record", $record)
						Return ""
					EndIf
					$rec = _StripMftRecord($rec, $FileRef)
					If $rec = "" Then
						_DebugOut($FileRef & " Extra record failed Fixup", $record)
						Return ""
					EndIf
					$str &= $rec		;no header or end marker
				Next
				$record = StringMid($record,1,($RecordSize-8)*2+2) & $str & "FFFFFFFF"       ;strip end first then add
			EndIf
		ElseIf $Type = 128 Then
			ReDim $DataQ[UBound($DataQ) + 1]
			$DataQ[UBound($DataQ) - 1] = StringMid($record,$AttributeOffset,$AttributeSize*2) 		;whole data attribute
		EndIf
		$AttributeOffset += $AttributeSize*2
	WEnd
	If ($IsMftFile And $MftIsBroken) Or ($IsMftFile And UBound($AttrQ) > 1) Then
		_GenDummyDataQ()
	EndIf
	Return $record
EndFunc

Func _DecodeMFTRecord($record, $FileRef)      ;produces DataQ
	If Not $SkipFixups Then $record = _DoFixup($record, $FileRef)
	If $record = "" then Return ""  ;corrupt, failed fixup
	$RecordSize = Dec(_SwapEndian(StringMid($record,51,8)),2)
	$AttributeOffset = (Dec(StringMid($record,43,2))*2)+3
	While 1		;only want Attribute List and Data Attributes
		$Type = Dec(_SwapEndian(StringMid($record,$AttributeOffset,8)),2)
		If $Type = 0 Or $Type > 256 Then ExitLoop		;attributes may not be in numerical order
		If $MFT_Record_Size = 1024 And $AttributeOffset > 2040 Then Exitloop
		$Flags = Dec(StringMid($record,47,4))
		$AttributeSize = Dec(_SwapEndian(StringMid($record,$AttributeOffset+8,8)),2)
		If $Type = 32 And $MftIsBroken = 0 Then
;			If $SkipFixups And $MftIsBroken Then Return "" ;Skip attribute lists because it simply will not work under this condition
			$AttrList = StringMid($record,$AttributeOffset,$AttributeSize*2)	;whole attribute
			$AttrList = _DecodeAttrList($FileRef, $AttrList)		;produces $AttrQ - extra record list
			If $AttrList = "" Then
				_DebugOut($FileRef & " Bad Attribute List signature", $record)
				Return ""
			Else
				If $AttrQ[0] = "" Then ContinueLoop		;no new records
				$str = ""
				For $i = 1 To $AttrQ[0]
					If Not IsNumber($FileTree[$AttrQ[$i]]) Then
						_DebugOut($FileRef & " Overwritten extra record (" & $AttrQ[$i] & ")", $record)
						Return ""
					EndIf
					$rec = _GetAttrListMFTRecord($FileTree[$AttrQ[$i]])
					If StringMid($rec,3,8) <> $RecordSignature Then
						_DebugOut($FileRef & " Bad signature for extra record", $record)
						Return ""
					EndIf
					If Dec(_SwapEndian(StringMid($rec,67,8)),2) <> $FileRef Then
						_DebugOut($FileRef & " Bad extra record", $record)
						Return ""
					EndIf
					$rec = _StripMftRecord($rec, $FileRef)
					If $rec = "" Then
						_DebugOut($FileRef & " Extra record failed Fixup", $record)
						Return ""
					EndIf
					$str &= $rec		;no header or end marker
				Next
				$record = StringMid($record,1,($RecordSize-8)*2+2) & $str & "FFFFFFFF"       ;strip end first then add
			EndIf
		ElseIf $Type = 48 Then
			Global $FileName = ""
			$attr = StringMid($record,$AttributeOffset,$AttributeSize*2)
			$NameSpace = StringMid($attr,179,2)
			If $NameSpace <> "02" Then
				$NameLength = Dec(StringMid($attr,177,2))
				$FileName = StringMid($attr,181,$NameLength*4)
				$FileName = BinaryToString("0x"&$FileName,2)
				If Not BitAND($Flags,Dec("0100")) Then $FileName = "[DEL]" & $FileName     ;deleted record
				Global $FN_Name = $FileName
			EndIf
		ElseIf $Type = 128 Then
			ReDim $DataQ[UBound($DataQ) + 1]
			$DataQ[UBound($DataQ) - 1] = StringMid($record,$AttributeOffset,$AttributeSize*2) 		;whole data attribute
		EndIf
		$AttributeOffset += $AttributeSize*2
	WEnd
	Return $record
EndFunc

Func _DoFixup($record, $FileRef)		;handles NT and XP style
	$UpdSeqArrOffset = Dec(_SwapEndian(StringMid($record,11,4)))
	$UpdSeqArrSize = Dec(_SwapEndian(StringMid($record,15,4)))
	$UpdSeqArr = StringMid($record,3+($UpdSeqArrOffset*2),$UpdSeqArrSize*2*2)
	If $MFT_Record_Size = 1024 Then
		$UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		$UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		$UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		$RecordEnd1 = StringMid($record,1023,4)
		$RecordEnd2 = StringMid($record,2047,4)
		If $UpdSeqArrPart0 <> $RecordEnd1 OR $UpdSeqArrPart0 <> $RecordEnd2 Then
			_DebugOut($FileRef & " The record failed Fixup", $record)
			Return ""
		EndIf
		Return StringMid($record,1,1022) & $UpdSeqArrPart1 & StringMid($record,1027,1020) & $UpdSeqArrPart2
	ElseIf $MFT_Record_Size = 4096 Then
		$UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		$UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		$UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		$UpdSeqArrPart3 = StringMid($UpdSeqArr,13,4)
		$UpdSeqArrPart4 = StringMid($UpdSeqArr,17,4)
		$UpdSeqArrPart5 = StringMid($UpdSeqArr,21,4)
		$UpdSeqArrPart6 = StringMid($UpdSeqArr,25,4)
		$UpdSeqArrPart7 = StringMid($UpdSeqArr,29,4)
		$UpdSeqArrPart8 = StringMid($UpdSeqArr,33,4)
		$RecordEnd1 = StringMid($record,1023,4)
		$RecordEnd2 = StringMid($record,2047,4)
		$RecordEnd3 = StringMid($record,3071,4)
		$RecordEnd4 = StringMid($record,4095,4)
		$RecordEnd5 = StringMid($record,5119,4)
		$RecordEnd6 = StringMid($record,6143,4)
		$RecordEnd7 = StringMid($record,7167,4)
		$RecordEnd8 = StringMid($record,8191,4)
		If $UpdSeqArrPart0 <> $RecordEnd1 OR $UpdSeqArrPart0 <> $RecordEnd2 OR $UpdSeqArrPart0 <> $RecordEnd3 OR $UpdSeqArrPart0 <> $RecordEnd4 OR $UpdSeqArrPart0 <> $RecordEnd5 OR $UpdSeqArrPart0 <> $RecordEnd6 OR $UpdSeqArrPart0 <> $RecordEnd7 OR $UpdSeqArrPart0 <> $RecordEnd8 Then
			_DebugOut($FileRef & " The record failed Fixup", $record)
			Return ""
		Else
			Return StringMid($record,1,1022) & $UpdSeqArrPart1 & StringMid($record,1027,1020) & $UpdSeqArrPart2 & StringMid($record,2051,1020) & $UpdSeqArrPart3 & StringMid($record,3075,1020) & $UpdSeqArrPart4 & StringMid($record,4099,1020) & $UpdSeqArrPart5 & StringMid($record,5123,1020) & $UpdSeqArrPart6 & StringMid($record,6147,1020) & $UpdSeqArrPart7 & StringMid($record,7171,1020) & $UpdSeqArrPart8
		EndIf
	EndIf
EndFunc

Func _GetAttrListMFTRecord($Pos)
   Local $nBytes
   _WinAPI_SetFilePointerEx($hDisk, $ImageOffset+$Pos, $FILE_BEGIN)
   _WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $MFT_Record_Size, $nBytes)
   $record = DllStructGetData($rBuffer, 1)
   Return $record		;returns MFT record for file
EndFunc

Func _ReadMFT()
   Local $nBytes
   If Not $IsMftFile Then
		_WinAPI_SetFilePointerEx($hDisk, $ImageOffset + $MFT_Offset)
	Else
		_WinAPI_SetFilePointerEx($hDisk, 0, $FILE_BEGIN)
	EndIf
   _WinAPI_ReadFile($hDisk, DllStructGetPtr($rBuffer), $MFT_Record_Size, $nBytes)
   $record = DllStructGetData($rBuffer, 1)
;   If StringMid($record,3,8) = $RecordSignature And StringMid($record,47,4) = "0100" Then Return $record		;returns record for MFT
   If StringMid($record,3,8) = $RecordSignature Then Return $record		;returns record for MFT  (also works for NT style records)
   If $MftIsBroken Then Return $record
   _DebugOut("Check record for $MFT", $record)	;bad $MFT record
   Return ""
EndFunc

Func _GetDiskConstants()
	Local $nbytes
	$tBuffer = DllStructCreate("byte[512]")
	$read = _WinAPI_ReadFile($hDisk, DllStructGetPtr($tBuffer), 512, $nBytes)
	If $read = 0 Then Return ""
	$record = DllStructGetData($tBuffer, 1)
	$BytesPerSector = Dec(_SwapEndian(StringMid($record,25,4)),2)
	$SectorsPerCluster = Dec(_SwapEndian(StringMid($record,29,2)),2)
	$BytesPerCluster = $BytesPerSector * $SectorsPerCluster;
	$LogicalClusterNumberforthefileMFT = Dec(_SwapEndian(StringMid($record,99,8)),2)
	$MFT_Offset = $BytesPerCluster * $LogicalClusterNumberforthefileMFT
	$ClustersPerFileRecordSegment = Dec(_SwapEndian(StringMid($record,131,8)),2)
	If Not $IsMftFile Then
		If $ClustersPerFileRecordSegment > 127 Then
			$MFT_Record_Size = 2 ^ (256 - $ClustersPerFileRecordSegment)
		Else
			$MFT_Record_Size = $BytesPerCluster * $ClustersPerFileRecordSegment
		EndIf
	Else
		If $MFT_Record_Size <> 1024 And $MFT_Record_Size <> 4096 Then Return ""
		Global $BytesPerCluster = 512*8
		Global $MFT_Offset = 0
	EndIf
	$ClustersPerFileRecordSegment = Ceiling($MFT_Record_Size/$BytesPerCluster)
   Return $record
EndFunc

Func _DisplayInfo($DebugInfo)
   GUICtrlSetData($myctredit, $DebugInfo, 1)
EndFunc

Func _GetMountedDrivesInfo()
	$IsPhysicalDrive=False
	GUICtrlSetData($Combo,"","")
	Local $menu = '', $Drive = DriveGetDrive('All')
	If @error Then
		_DisplayInfo("Error - something went wrong in Func _GetPhysicalDriveInfo" & @CRLF)
		Return
	EndIf
	For $i = 1 to $Drive[0]
		$DriveType = DriveGetType($Drive[$i])
		$DriveCapacity = Round(DriveSpaceTotal($Drive[$i]),0)
		If DriveGetFileSystem($Drive[$i]) = 'NTFS' Then
			$menu &=  StringUpper($Drive[$i]) & "  (" & $DriveType & ")  - " & $DriveCapacity & " MB  - NTFS|"
		EndIf
	Next
	If $menu Then
		_DisplayInfo("NTFS drives detected" & @CRLF)
		GUICtrlSetData($Combo, $menu, StringMid($menu, 1, StringInStr($menu, "|") -1))
		$IsImage = False
	Else
		_DisplayInfo("No NTFS drives detected" & @CRLF)
	EndIf
EndFunc

Func _DecToLittleEndian($DecimalInput)
   Return _SwapEndian(Hex($DecimalInput,8))
EndFunc

Func _SwapEndian($iHex)
   Return StringMid(Binary(Dec($iHex,2)),3, StringLen($iHex))
EndFunc

Func _DebugOut($text, $var="")
   If $var Then $var = _HexEncode($var) & @CRLF
   $text &= @CRLF & $var
   ConsoleWrite($text)
   If $logfile Then FileWrite($logfile, $text)
EndFunc

; start: by trancexxx --------------------------------------
Func _HexEncode($bInput)
   Local $tInput = DllStructCreate("byte[" & BinaryLen($bInput) & "]")
   DllStructSetData($tInput, 1, $bInput)
   Local $a_iCall = DllCall("crypt32.dll", "int", "CryptBinaryToString", _
	  "ptr", DllStructGetPtr($tInput), _
	  "dword", DllStructGetSize($tInput), _
	  "dword", 11, _
	  "ptr", 0, _
	  "dword*", 0)

   If @error Or Not $a_iCall[0] Then
	  Return SetError(1, 0, "")
   EndIf
   Local $iSize = $a_iCall[5]
   Local $tOut = DllStructCreate("char[" & $iSize & "]")
   $a_iCall = DllCall("crypt32.dll", "int", "CryptBinaryToString", _
	  "ptr", DllStructGetPtr($tInput), _
	  "dword", DllStructGetSize($tInput), _
	  "dword", 11, _
	  "ptr", DllStructGetPtr($tOut), _
	  "dword*", $iSize)

   If @error Or Not $a_iCall[0] Then
	  Return SetError(2, 0, "")
   EndIf

   Return SetError(0, 0, DllStructGetData($tOut, 1))
EndFunc

Func _LZNTDecompress($tInput, $Size)	;note function returns a null string if error, or an array if no error
	Local $tOutput[2]
	Local $cBuffer = DllStructCreate("byte[" & $BytesPerCluster*16 & "]")
    Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
            "ushort", 2, _
            "ptr", DllStructGetPtr($cBuffer), _
            "dword", DllStructGetSize($cBuffer), _
            "ptr", DllStructGetPtr($tInput), _
            "dword", $Size, _
            "dword*", 0)

    If @error Or $a_Call[0] Then	;if $a_Call[0]=0 then output size is in $a_Call[6], otherwise $a_Call[6] is invalid
        Return SetError(1, 0, "") ; error decompressing
    EndIf
    Local $Decompressed = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($cBuffer))
	$tOutput[0] = DllStructGetData($Decompressed, 1)
	$tOutput[1] = $a_Call[6]
    Return SetError(0, 0, $tOutput)
EndFunc
; end: by trancexxx -------------------------------------

Func _DoFileTreeProgress()
    GUICtrlSetData($ProgressStatus, "First examination of MFT record " & $CurrentProgress & " of " & $Total & " (step 1 of 3)")
    GUICtrlSetData($ElapsedTime, "Elapsed time = " & _WinAPI_StrFromTimeInterval(TimerDiff($begin)))
	GUICtrlSetData($OverallProgress, 100 * $CurrentProgress / $Total)
EndFunc

Func _FolderStrucProgress()
	GUICtrlSetData($ProgressStatus, "Resolving paths " & $CurrentProgress & " of " & $Total & " (step 2 of 3)")
	GUICtrlSetData($ElapsedTime, "Elapsed time = " & _WinAPI_StrFromTimeInterval(TimerDiff($begin)))
    GUICtrlSetData($OverallProgress, 100 * $CurrentProgress / $Total)
EndFunc

Func _ExtractionProgress()
	GUICtrlSetData($ProgressStatus, "Decoding record " & $CurrentProgress & " of " & $Total & " (step 3 of 3)")
	GUICtrlSetData($ElapsedTime, "Elapsed time = " & _WinAPI_StrFromTimeInterval(TimerDiff($begin)))
    GUICtrlSetData($OverallProgress, 100 * $CurrentProgress / $Total)
	GUICtrlSetData($ProgressFileName, $FN_Name)
	GUICtrlSetData($FileProgress, 100 * ($DT_RealSize - $ProgressSize) / $DT_RealSize)
EndFunc

Func _ProcessImage()
	$TargetImageFile = FileOpenDialog("Select image file",@ScriptDir,"All (*.*)")
	If @error then Return
	$TargetImageFile = "\\.\"&$TargetImageFile
	_DisplayInfo("Selected disk image file: " & $TargetImageFile & @CRLF)
	GUICtrlSetData($Combo,"","")
	$Entries = ''
	_CheckMBR()
	GUICtrlSetData($Combo,$Entries,StringMid($Entries, 1, StringInStr($Entries, "|") -1))
	If $Entries = "" Then _DisplayInfo("Sorry, no NTFS volume found in that file." & @CRLF)
EndFunc   ;==>_ProcessImage

Func _CheckMBR()
	Local $nbytes, $PartitionNumber, $PartitionEntry,$FilesystemDescriptor
	Local $StartingSector,$NumberOfSectors
	Local $hImage = _WinAPI_CreateFile($TargetImageFile,2,2,7)
	$tBuffer = DllStructCreate("byte[512]")
	Local $read = _WinAPI_ReadFile($hImage, DllStructGetPtr($tBuffer), 512, $nBytes)
	If $read = 0 Then Return ""
	Local $sector = DllStructGetData($tBuffer, 1)
	For $PartitionNumber = 0 To 3
		$PartitionEntry = StringMid($sector,($PartitionNumber*32)+3+892,32)
		If $PartitionEntry = "00000000000000000000000000000000" Then ExitLoop ; No more entries
		$FilesystemDescriptor = StringMid($PartitionEntry,9,2)
		$StartingSector = Dec(_SwapEndian(StringMid($PartitionEntry,17,8)),2)
		$NumberOfSectors = Dec(_SwapEndian(StringMid($PartitionEntry,25,8)),2)
		If ($FilesystemDescriptor = "EE" and $StartingSector = 1 and $NumberOfSectors = 4294967295) Then ; A typical dummy partition to prevent overwriting of GPT data, also known as "protective MBR"
			_CheckGPT($hImage)
		ElseIf $FilesystemDescriptor = "05" Or $FilesystemDescriptor = "0F" Then ;Extended partition
			_CheckExtendedPartition($StartingSector, $hImage)
		ElseIf $FilesystemDescriptor = "07" Then ;Marked as NTFS
			$Entries &= _GenComboDescription($StartingSector,$NumberOfSectors)
		EndIf
    Next
	If $Entries = "" Then ;Also check if pure partition image (without mbr)
		$NtfsVolumeSize = _TestNTFS($hImage, 0)
		If $NtfsVolumeSize Then $Entries = _GenComboDescription(0,$NtfsVolumeSize)
	EndIf
	_WinAPI_CloseHandle($hImage)
EndFunc   ;==>_CheckMBR

Func _CheckGPT($hImage) ; Assume GPT to be present at sector 1, which is not fool proof
   ;Actually it is. While LBA1 may not be at sector 1 on the disk, it will always be there in an image.
	Local $nbytes,$read,$sector,$GPTSignature,$StartLBA,$Processed=0,$FirstLBA,$LastLBA
	$tBuffer = DllStructCreate("byte[512]")
	$read = _WinAPI_ReadFile($hImage, DllStructGetPtr($tBuffer), 512, $nBytes)		;read second sector
	If $read = 0 Then Return ""
	$sector = DllStructGetData($tBuffer, 1)
	$GPTSignature = StringMid($sector,3,16)
	If $GPTSignature <> "4546492050415254" Then
		_DebugOut("Error: Could not find GPT signature:", StringMid($sector,3))
		Return
	EndIf
	$StartLBA = Dec(_SwapEndian(StringMid($sector,147,16)),2)
	$PartitionsInArray = Dec(_SwapEndian(StringMid($sector,163,8)),2)
	$PartitionEntrySize = Dec(_SwapEndian(StringMid($sector,171,8)),2)
	_WinAPI_SetFilePointerEx($hImage, $StartLBA*512, $FILE_BEGIN)
	$SizeNeeded = $PartitionsInArray*$PartitionEntrySize ;Set buffer size -> maximum number of partition entries that can fit in the array
	$tBuffer = DllStructCreate("byte[" & $SizeNeeded & "]")
	$read = _WinAPI_ReadFile($hImage, DllStructGetPtr($tBuffer), $SizeNeeded, $nBytes)
	If $read = 0 Then Return ""
	$sector = DllStructGetData($tBuffer, 1)
	Do
		$FirstLBA = Dec(_SwapEndian(StringMid($sector,67+($Processed*2),16)),2)
		$LastLBA = Dec(_SwapEndian(StringMid($sector,83+($Processed*2),16)),2)
		If $FirstLBA = 0 And $LastLBA = 0 Then ExitLoop ; No more entries
		$Processed += $PartitionEntrySize
		If Not _TestNTFS($hImage, $FirstLBA) Then ContinueLoop ;Continue the loop if filesystem not NTFS
		$Entries &= _GenComboDescription($FirstLBA,$LastLBA-$FirstLBA)
	Until $Processed >= $SizeNeeded
EndFunc   ;==>_CheckGPT

Func _CheckExtendedPartition($StartSector, $hImage)	;Extended partitions can only contain Logical Drives, but can be more than 4
   Local $nbytes,$read,$sector,$NextEntry=0,$StartingSector,$NumberOfSectors,$PartitionTable,$FilesystemDescriptor
   $tBuffer = DllStructCreate("byte[512]")
   While 1
	  _WinAPI_SetFilePointerEx($hImage, ($StartSector + $NextEntry) * 512, $FILE_BEGIN)
	  $read = _WinAPI_ReadFile($hImage, DllStructGetPtr($tBuffer), 512, $nBytes)
	  If $read = 0 Then Return ""
	  $sector = DllStructGetData($tBuffer, 1)
	  $PartitionTable = StringMid($sector,3+892,64)
	  $FilesystemDescriptor = StringMid($PartitionTable,9,2)
	  $StartingSector = $StartSector+$NextEntry+Dec(_SwapEndian(StringMid($PartitionTable,17,8)),2)
	  $NumberOfSectors = Dec(_SwapEndian(StringMid($PartitionTable,25,8)),2)
	  If $FilesystemDescriptor = "07" Then $Entries &= _GenComboDescription($StartingSector,$NumberOfSectors)
	  If StringMid($PartitionTable,33) = "00000000000000000000000000000000" Then ExitLoop ; No more entries
	  $NextEntry = Dec(_SwapEndian(StringMid($PartitionTable,49,8)),2)
   WEnd
EndFunc   ;==>_CheckExtendedPartition

Func _TestNTFS($hImage, $PartitionStartSector)
	Local $nbytes, $TotalSectors
	If $PartitionStartSector <> 0 Then
		_WinAPI_SetFilePointerEx($hImage, $PartitionStartSector*512, $FILE_BEGIN)
	Else
		_WinAPI_CloseHandle($hImage)
		$hImage = _WinAPI_CreateFile($TargetImageFile,2,2,7)
	EndIf
	$tBuffer = DllStructCreate("byte[512]")
	$read = _WinAPI_ReadFile($hImage, DllStructGetPtr($tBuffer), 512, $nBytes)
	If $read = 0 Then Return ""
	$sector = DllStructGetData($tBuffer, 1)
	$TestSig = StringMid($sector,9,8)
	$TotalSectors = Dec(_SwapEndian(StringMid($sector,83,8)),2)
	If $TestSig = "4E544653" Then Return $TotalSectors		; Volume is NTFS
	_DebugOut("Could not find NTFS:", $sector)		; Volume is not NTFS
    Return 0
EndFunc   ;==>_TestNTFS

Func _GenComboDescription($StartSector,$SectorNumber)
	Return "Offset = " & $StartSector*512 & ": Volume size = " & Round(($SectorNumber*512)/1024/1024/1024,2) & " GB|"
EndFunc   ;==>_GenComboDescription

Func _SelectMftFile()
	$TargetMftFile = FileOpenDialog("Select $MFT file",@ScriptDir,"All (*.*)")
	If @error then Return
	_DisplayInfo("Selected $MFT file: " & $TargetMftFile & @CRLF)
	GUICtrlSetData($Combo,"","")
	$Entries = ''
EndFunc   ;==>_SelectMftFile

Func _ParserCodeOldVersion($MFTEntry)
	$FN_Number = 0
	$DT_Number = 0
	$UpdSeqArrOffset = ""
	$UpdSeqArrSize = ""
	$UpdSeqArrOffset = StringMid($MFTEntry, 11, 4)
	$UpdSeqArrOffset = Dec(_SwapEndian($UpdSeqArrOffset),2)
	$UpdSeqArrSize = StringMid($MFTEntry, 15, 4)
	$UpdSeqArrSize = Dec(_SwapEndian($UpdSeqArrSize),2)
	$UpdSeqArr = StringMid($MFTEntry, 3 + ($UpdSeqArrOffset * 2), $UpdSeqArrSize * 2 * 2)

	If $MFT_Record_Size = 1024 Then
		Local $UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		Local $UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		Local $UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		Local $RecordEnd1 = StringMid($MFTEntry,1023,4)
		Local $RecordEnd2 = StringMid($MFTEntry,2047,4)
		If $RecordEnd1 <> $RecordEnd2 Or $UpdSeqArrPart0 <> $RecordEnd1 Then
			$IntegrityCheck = "BAD"
		Else
			$IntegrityCheck = "OK"
		EndIf
		$MFTEntry = StringMid($MFTEntry,1,1022) & $UpdSeqArrPart1 & StringMid($MFTEntry,1027,1020) & $UpdSeqArrPart2
	ElseIf $MFT_Record_Size = 4096 Then
		Local $UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		Local $UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		Local $UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		Local $UpdSeqArrPart3 = StringMid($UpdSeqArr,13,4)
		Local $UpdSeqArrPart4 = StringMid($UpdSeqArr,17,4)
		Local $UpdSeqArrPart5 = StringMid($UpdSeqArr,21,4)
		Local $UpdSeqArrPart6 = StringMid($UpdSeqArr,25,4)
		Local $UpdSeqArrPart7 = StringMid($UpdSeqArr,29,4)
		Local $UpdSeqArrPart8 = StringMid($UpdSeqArr,33,4)
		Local $RecordEnd1 = StringMid($MFTEntry,1023,4)
		Local $RecordEnd2 = StringMid($MFTEntry,2047,4)
		Local $RecordEnd3 = StringMid($MFTEntry,3071,4)
		Local $RecordEnd4 = StringMid($MFTEntry,4095,4)
		Local $RecordEnd5 = StringMid($MFTEntry,5119,4)
		Local $RecordEnd6 = StringMid($MFTEntry,6143,4)
		Local $RecordEnd7 = StringMid($MFTEntry,7167,4)
		Local $RecordEnd8 = StringMid($MFTEntry,8191,4)
		If $UpdSeqArrPart0 <> $RecordEnd1 OR $UpdSeqArrPart0 <> $RecordEnd2 OR $UpdSeqArrPart0 <> $RecordEnd3 OR $UpdSeqArrPart0 <> $RecordEnd4 OR $UpdSeqArrPart0 <> $RecordEnd5 OR $UpdSeqArrPart0 <> $RecordEnd6 OR $UpdSeqArrPart0 <> $RecordEnd7 OR $UpdSeqArrPart0 <> $RecordEnd8 Then
			$IntegrityCheck = "BAD"
		Else
			$IntegrityCheck = "OK"
		EndIf
		$MFTEntry =  StringMid($MFTEntry,1,1022) & $UpdSeqArrPart1 & StringMid($MFTEntry,1027,1020) & $UpdSeqArrPart2 & StringMid($MFTEntry,2051,1020) & $UpdSeqArrPart3 & StringMid($MFTEntry,3075,1020) & $UpdSeqArrPart4 & StringMid($MFTEntry,4099,1020) & $UpdSeqArrPart5 & StringMid($MFTEntry,5123,1020) & $UpdSeqArrPart6 & StringMid($MFTEntry,6147,1020) & $UpdSeqArrPart7 & StringMid($MFTEntry,7171,1020) & $UpdSeqArrPart8
	EndIf

	$HDR_LSN = StringMid($MFTEntry, 19, 16)
	$HDR_LSN = Dec(_SwapEndian($HDR_LSN),2)
	$HDR_SequenceNo = StringMid($MFTEntry, 35, 4)
	$HDR_SequenceNo = Dec(_SwapEndian($HDR_SequenceNo),2)
	$HDR_HardLinkCount = StringMid($MFTEntry,39,4)
	$HDR_HardLinkCount = Dec(_SwapEndian($HDR_HardLinkCount),2)
	$HDR_Flags = StringMid($MFTEntry, 47, 4);00=deleted file,01=file,02=deleted folder,03=folder
	Select
		Case $HDR_Flags = '0000'
			$HDR_Flags = 'FILE'
			$RecordActive = 'DELETED'
		Case $HDR_Flags = '0100'
			$HDR_Flags = 'FILE'
			$RecordActive = 'ALLOCATED'
		Case $HDR_Flags = '0200'
			$HDR_Flags = 'FOLDER'
			$RecordActive = 'DELETED'
		Case $HDR_Flags = '0300'
			$HDR_Flags = 'FOLDER'
			$RecordActive = 'ALLOCATED'
		Case $HDR_Flags = '0400'
			$HDR_Flags = 'FILE+USNJRNL+DISABLED'
			$RecordActive = 'ALLOCATED'
		Case $HDR_Flags = '0500'
			$HDR_Flags = 'FILE+USNJRNL+ENABLED'
			$RecordActive = 'ALLOCATED'
		Case $HDR_Flags = '0900'
			$HDR_Flags = 'FILE+INDEX_SECURITY'
			$RecordActive = 'ALLOCATED'
		Case $HDR_Flags = '0D00'
			$HDR_Flags = 'FILE+INDEX_OTHER'
			$RecordActive = 'ALLOCATED'
		Case Else
			$HDR_Flags = 'UNKNOWN'
			$RecordActive = 'UNKNOWN'
	EndSelect
	$HDR_RecRealSize = StringMid($MFTEntry, 51, 8)
	$HDR_RecRealSize = Dec(_SwapEndian($HDR_RecRealSize),2)
	$HDR_RecAllocSize = StringMid($MFTEntry, 59, 8)
	$HDR_RecAllocSize = Dec(_SwapEndian($HDR_RecAllocSize),2)
	$HDR_BaseRecord = StringMid($MFTEntry, 67, 12)
	$HDR_BaseRecord = Dec(_SwapEndian($HDR_BaseRecord),2)
	$HDR_BaseRecSeqNo = StringMid($MFTEntry, 79, 4)
	$HDR_BaseRecSeqNo = Dec(_SwapEndian($HDR_BaseRecSeqNo),2)
	$HDR_NextAttribID = StringMid($MFTEntry, 83, 4)
	$HDR_NextAttribID = "0x"&_SwapEndian($HDR_NextAttribID)
	If $UpdSeqArrOffset = 48 Then
		$HDR_MFTREcordNumber = StringMid($MFTEntry, 91, 8)
		$HDR_MFTREcordNumber = Dec(_SwapEndian($HDR_MFTREcordNumber),2)
	Else
		$HDR_MFTREcordNumber = $GlobalRefCounter
		$style = "NT style"
		$HDR_Flags = ''
	EndIf
	$GlobalRefCounter+=1
	$NextAttributeOffset = (Dec(StringMid($MFTEntry, 43, 2)) * 2) + 3
	$AttributeType = StringMid($MFTEntry, $NextAttributeOffset, 8)
	$AttributeSize = StringMid($MFTEntry, $NextAttributeOffset + 8, 8)
	$AttributeSize = Dec(_SwapEndian($AttributeSize),2)
	$AttributeKnown = 1
	While $AttributeKnown = 1
		$NextAttributeType = StringMid($MFTEntry, $NextAttributeOffset, 8)
		$AttributeType = $NextAttributeType
		$AttributeSize = StringMid($MFTEntry, $NextAttributeOffset + 8, 8)
		$AttributeSize = Dec(_SwapEndian($AttributeSize),2)
		Select
			Case $AttributeType = $STANDARD_INFORMATION
				$AttributeKnown = 1
				$SI_ON = 1
				_Get_StandardInformation($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $ATTRIBUTE_LIST
				$AttributeKnown = 1
				$AL_ON = 1
				;			_Get_AttributeList()

			Case $AttributeType = $FILE_NAME
				$AttributeKnown = 1
				$FN_ON = 1
				$FN_Number += 1 ; Need to come up with something smarter than this
				If $FN_Number > 4 Then ContinueCase
				_Get_FileName($MFTEntry, $NextAttributeOffset, $AttributeSize, $FN_Number)

			Case $AttributeType = $OBJECT_ID
				$AttributeKnown = 1
				$OI_ON = 1
				If $DoDefaultAll Then _Get_ObjectID($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $SECURITY_DESCRIPTOR
				$AttributeKnown = 1
				$SD_ON = 1
				;			_Get_SecurityDescriptor()

			Case $AttributeType = $VOLUME_NAME
				$AttributeKnown = 1
				$VN_ON = 1
				If $DoDefaultAll Then _Get_VolumeName($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $VOLUME_INFORMATION
				$AttributeKnown = 1
				$VI_ON = 1
				If $DoDefaultAll Then _Get_VolumeInformation($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $DATA
				$AttributeKnown = 1
				$DT_ON = 1
				$DT_Number += 1
				If $DT_Number > 3 Then ContinueCase
				_Get_Data($MFTEntry, $NextAttributeOffset, $AttributeSize, $DT_Number)

			Case $AttributeType = $INDEX_ROOT
				$AttributeKnown = 1
				$IR_ON = 1
				;			_Get_IndexRoot()

			Case $AttributeType = $INDEX_ALLOCATION
				$AttributeKnown = 1
				$IA_ON = 1
				;			_Get_IndexAllocation()

			Case $AttributeType = $BITMAP
				$AttributeKnown = 1
				$BITMAP_ON = 1
				;			_Get_Bitmap()

			Case $AttributeType = $REPARSE_POINT
				$AttributeKnown = 1
				$RP_ON = 1
				;			_Get_ReparsePoint()

			Case $AttributeType = $EA_INFORMATION
				$AttributeKnown = 1
				$EAI_ON = 1
				;			_Get_EaInformation()

			Case $AttributeType = $EA
				$AttributeKnown = 1
				$EA_ON = 1
				;			_Get_Ea()

			Case $AttributeType = $PROPERTY_SET
				$AttributeKnown = 1
				$PS_ON = 1
				;			_Get_PropertySet()

			Case $AttributeType = $LOGGED_UTILITY_STREAM
				$AttributeKnown = 1
				$LUS_ON = 1
				;			_Get_LoggedUtilityStream()

			Case $AttributeType = $ATTRIBUTE_END_MARKER
				$AttributeKnown = 0
;				ConsoleWrite("No more attributes in this record." & @CRLF)

			Case $AttributeType <> $LOGGED_UTILITY_STREAM And $AttributeType <> $EA And $AttributeType <> $EA_INFORMATION And $AttributeType <> $REPARSE_POINT And $AttributeType <> $BITMAP And $AttributeType <> $INDEX_ALLOCATION And $AttributeType <> $INDEX_ROOT And $AttributeType <> $DATA And $AttributeType <> $VOLUME_INFORMATION And $AttributeType <> $VOLUME_NAME And $AttributeType <> $SECURITY_DESCRIPTOR And $AttributeType <> $OBJECT_ID And $AttributeType <> $FILE_NAME And $AttributeType <> $ATTRIBUTE_LIST And $AttributeType <> $STANDARD_INFORMATION And $AttributeType <> $PROPERTY_SET And $AttributeType <> $ATTRIBUTE_END_MARKER
				$AttributeKnown = 0
;				ConsoleWrite("Unknown attribute found in this record." & @CRLF)

		EndSelect

		$NextAttributeOffset = $NextAttributeOffset + ($AttributeSize * 2)
	WEnd
EndFunc

Func _Get_StandardInformation($MFTEntry, $SI_Offset, $SI_Size)
	$SI_HEADER_Flags = StringMid($MFTEntry, $SI_Offset + 24, 4)
	$SI_HEADER_Flags = _SwapEndian($SI_HEADER_Flags)
	$SI_HEADER_Flags = _AttribHeaderFlags("0x" & $SI_HEADER_Flags)
	;
;	$SI_CTime = StringMid($MFTEntry, $SI_Offset + 48, 16)
;	$SI_CTime = _SwapEndian($SI_CTime)
;	$SI_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_CTime)
;	$SI_CTime = _WinTime_UTCFileTimeFormat(Dec($SI_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;	$SI_CTime = $SI_CTime & ":" & _FillZero(StringRight($SI_CTime_tmp, 4))
;	$MSecTest = _Test_MilliSec($SI_CTime)
;
	$SI_CTime = StringMid($MFTEntry, $SI_Offset + 48, 16)
	$SI_CTime = _SwapEndian($SI_CTime)
	$SI_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_CTime)
	$SI_CTime = _WinTime_UTCFileTimeFormat(Dec($SI_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$SI_CTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 2 Then
		$SI_CTime_Core = StringMid($SI_CTime,1,StringLen($SI_CTime)-4)
		$SI_CTime_Precision = StringRight($SI_CTime,3)
	ElseIf $TimestampPrecision = 3 Then
		$SI_CTime = $SI_CTime & $PrecisionSeparator2 & _FillZero(StringRight($SI_CTime_tmp, 4))
		$MSecTest = _Test_MilliSec($SI_CTime)
		$SI_CTime_Core = StringMid($SI_CTime,1,StringLen($SI_CTime)-9)
		$SI_CTime_Precision = StringRight($SI_CTime,8)
	Else
		$SI_CTime_Core = $SI_CTime
	EndIf
	;
;	$SI_ATime = StringMid($MFTEntry, $SI_Offset + 64, 16)
;	$SI_ATime = _SwapEndian($SI_ATime)
;	$SI_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_ATime)
;	$SI_ATime = _WinTime_UTCFileTimeFormat(Dec($SI_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;	$SI_ATime = $SI_ATime & ":" & _FillZero(StringRight($SI_ATime_tmp, 4))
	;
	$SI_ATime = StringMid($MFTEntry, $SI_Offset + 64, 16)
	$SI_ATime = _SwapEndian($SI_ATime)
	$SI_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_ATime)
	$SI_ATime = _WinTime_UTCFileTimeFormat(Dec($SI_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$SI_ATime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 2 Then
		$SI_ATime_Core = StringMid($SI_ATime,1,StringLen($SI_ATime)-4)
		$SI_ATime_Precision = StringRight($SI_ATime,3)
	ElseIf $TimestampPrecision = 3 Then
		$SI_ATime = $SI_ATime & $PrecisionSeparator2 & _FillZero(StringRight($SI_ATime_tmp, 4))
		$SI_ATime_Core = StringMid($SI_ATime,1,StringLen($SI_ATime)-9)
		$SI_ATime_Precision = StringRight($SI_ATime,8)
	Else
		$SI_ATime_Core = $SI_ATime
	EndIf
	;
;	$SI_MTime = StringMid($MFTEntry, $SI_Offset + 80, 16)
;	$SI_MTime = _SwapEndian($SI_MTime)
;	$SI_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_MTime)
;	$SI_MTime = _WinTime_UTCFileTimeFormat(Dec($SI_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;	$SI_MTime = $SI_MTime & ":" & _FillZero(StringRight($SI_MTime_tmp, 4))
	;
	$SI_MTime = StringMid($MFTEntry, $SI_Offset + 80, 16)
	$SI_MTime = _SwapEndian($SI_MTime)
	$SI_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_MTime)
	$SI_MTime = _WinTime_UTCFileTimeFormat(Dec($SI_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$SI_MTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 2 Then
		$SI_MTime_Core = StringMid($SI_MTime,1,StringLen($SI_MTime)-4)
		$SI_MTime_Precision = StringRight($SI_MTime,3)
	ElseIf $TimestampPrecision = 3 Then
		$SI_MTime = $SI_MTime & $PrecisionSeparator2 & _FillZero(StringRight($SI_MTime_tmp, 4))
		$SI_MTime_Core = StringMid($SI_MTime,1,StringLen($SI_MTime)-9)
		$SI_MTime_Precision = StringRight($SI_MTime,8)
	Else
		$SI_MTime_Core = $SI_MTime
	EndIf
	;
;	$SI_RTime = StringMid($MFTEntry, $SI_Offset + 96, 16)
;	$SI_RTime = _SwapEndian($SI_RTime)
;	$SI_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_RTime)
;	$SI_RTime = _WinTime_UTCFileTimeFormat(Dec($SI_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;	$SI_RTime = $SI_RTime & ":" & _FillZero(StringRight($SI_RTime_tmp, 4))
	;
	$SI_RTime = StringMid($MFTEntry, $SI_Offset + 96, 16)
	$SI_RTime = _SwapEndian($SI_RTime)
	$SI_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SI_RTime)
	$SI_RTime = _WinTime_UTCFileTimeFormat(Dec($SI_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$SI_RTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 2 Then
		$SI_RTime_Core = StringMid($SI_RTime,1,StringLen($SI_RTime)-4)
		$SI_RTime_Precision = StringRight($SI_RTime,3)
	ElseIf $TimestampPrecision = 3 Then
		$SI_RTime = $SI_RTime & $PrecisionSeparator2 & _FillZero(StringRight($SI_RTime_tmp, 4))
		$SI_RTime_Core = StringMid($SI_RTime,1,StringLen($SI_RTime)-9)
		$SI_RTime_Precision = StringRight($SI_RTime,8)
	Else
		$SI_RTime_Core = $SI_RTime
	EndIf
	;
	If Not $DoDefaultAll Then Return
	$SI_FilePermission = StringMid($MFTEntry, $SI_Offset + 112, 8)
	$SI_FilePermission = _SwapEndian($SI_FilePermission)
	$SI_FilePermission = _File_Permissions("0x" & $SI_FilePermission)
	$SI_MaxVersions = StringMid($MFTEntry, $SI_Offset + 120, 8)
	$SI_MaxVersions = Dec(_SwapEndian($SI_MaxVersions),2)
	$SI_VersionNumber = StringMid($MFTEntry, $SI_Offset + 128, 8)
	$SI_VersionNumber = Dec(_SwapEndian($SI_VersionNumber),2)
	$SI_ClassID = StringMid($MFTEntry, $SI_Offset + 136, 8)
	$SI_ClassID = Dec(_SwapEndian($SI_ClassID),2)
	$SI_OwnerID = StringMid($MFTEntry, $SI_Offset + 144, 8)
	$SI_OwnerID = Dec(_SwapEndian($SI_OwnerID),2)
	$SI_SecurityID = StringMid($MFTEntry, $SI_Offset + 152, 8)
	$SI_SecurityID = Dec(_SwapEndian($SI_SecurityID),2)
	$SI_Quota = StringMid($MFTEntry, $SI_Offset + 160, 8)
	$SI_Quota = Dec(_SwapEndian($SI_Quota),2)
	$SI_USN = StringMid($MFTEntry, $SI_Offset + 176, 16)
	$SI_USN = Dec(_SwapEndian($SI_USN),2)
EndFunc   ;==>_Get_StandardInformation

Func _Get_AttributeList()
;	ConsoleWrite("Get_AttributeList Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_AttributeList

Func _Get_FileName($MFTEntry, $FN_Offset, $FN_Size, $FN_Number)
	If $FN_Number = 1 Then
		$FN_ParentRefNo = StringMid($MFTEntry, $FN_Offset + 48, 12)
		$FN_ParentRefNo = Dec(_SwapEndian($FN_ParentRefNo),2)
		$FN_ParentSeqNo = StringMid($MFTEntry, $FN_Offset + 60, 4)
		$FN_ParentSeqNo = Dec(_SwapEndian($FN_ParentSeqNo),2)
		;
;		$FN_CTime = StringMid($MFTEntry, $FN_Offset + 64, 16)
;		$FN_CTime = _SwapEndian($FN_CTime)
;		$FN_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime)
;		$FN_CTime = _WinTime_UTCFileTimeFormat(Dec($FN_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_CTime = $FN_CTime & ":" & _FillZero(StringRight($FN_CTime_tmp, 4))
		;
		$FN_CTime = StringMid($MFTEntry, $FN_Offset + 64, 16)
		$FN_CTime = _SwapEndian($FN_CTime)
		$FN_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime)
		$FN_CTime = _WinTime_UTCFileTimeFormat(Dec($FN_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_CTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_CTime_Core = StringMid($FN_CTime,1,StringLen($FN_CTime)-4)
			$FN_CTime_Precision = StringRight($FN_CTime,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_CTime = $FN_CTime & $PrecisionSeparator2 & _FillZero(StringRight($FN_CTime_tmp, 4))
			$FN_CTime_Core = StringMid($FN_CTime,1,StringLen($FN_CTime)-9)
			$FN_CTime_Precision = StringRight($FN_CTime,8)
		Else
			$FN_CTime_Core = $FN_CTime
		EndIf
		;
;		$FN_ATime = StringMid($MFTEntry, $FN_Offset + 80, 16)
;		$FN_ATime = _SwapEndian($FN_ATime)
;		$FN_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime)
;		$FN_ATime = _WinTime_UTCFileTimeFormat(Dec($FN_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_ATime = $FN_ATime & ":" & _FillZero(StringRight($FN_ATime_tmp, 4))
		;
		$FN_ATime = StringMid($MFTEntry, $FN_Offset + 80, 16)
		$FN_ATime = _SwapEndian($FN_ATime)
		$FN_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime)
		$FN_ATime = _WinTime_UTCFileTimeFormat(Dec($FN_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_ATime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_ATime_Core = StringMid($FN_ATime,1,StringLen($FN_ATime)-4)
			$FN_ATime_Precision = StringRight($FN_ATime,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_ATime = $FN_ATime & $PrecisionSeparator2 & _FillZero(StringRight($FN_ATime_tmp, 4))
			$FN_ATime_Core = StringMid($FN_ATime,1,StringLen($FN_ATime)-9)
			$FN_ATime_Precision = StringRight($FN_ATime,8)
		Else
			$FN_ATime_Core = $FN_ATime
		EndIf
		;
;		$FN_MTime = StringMid($MFTEntry, $FN_Offset + 96, 16)
;		$FN_MTime = _SwapEndian($FN_MTime)
;		$FN_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime)
;		$FN_MTime = _WinTime_UTCFileTimeFormat(Dec($FN_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_MTime = $FN_MTime & ":" & _FillZero(StringRight($FN_MTime_tmp, 4))
		;
		$FN_MTime = StringMid($MFTEntry, $FN_Offset + 96, 16)
		$FN_MTime = _SwapEndian($FN_MTime)
		$FN_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime)
		$FN_MTime = _WinTime_UTCFileTimeFormat(Dec($FN_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_MTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_MTime_Core = StringMid($FN_MTime,1,StringLen($FN_MTime)-4)
			$FN_MTime_Precision = StringRight($FN_MTime,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_MTime = $FN_MTime & $PrecisionSeparator2 & _FillZero(StringRight($FN_MTime_tmp, 4))
			$FN_MTime_Core = StringMid($FN_MTime,1,StringLen($FN_MTime)-9)
			$FN_MTime_Precision = StringRight($FN_MTime,8)
		Else
			$FN_MTime_Core = $FN_MTime
		EndIf
		;
;		$FN_RTime = StringMid($MFTEntry, $FN_Offset + 112, 16)
;		$FN_RTime = _SwapEndian($FN_RTime)
;		$FN_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime)
;		$FN_RTime = _WinTime_UTCFileTimeFormat(Dec($FN_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_RTime = $FN_RTime & ":" & _FillZero(StringRight($FN_RTime_tmp, 4))
		;
		$FN_RTime = StringMid($MFTEntry, $FN_Offset + 112, 16)
		$FN_RTime = _SwapEndian($FN_RTime)
		$FN_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime)
		$FN_RTime = _WinTime_UTCFileTimeFormat(Dec($FN_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_RTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_RTime_Core = StringMid($FN_RTime,1,StringLen($FN_RTime)-4)
			$FN_RTime_Precision = StringRight($FN_RTime,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_RTime = $FN_RTime & $PrecisionSeparator2 & _FillZero(StringRight($FN_RTime_tmp, 4))
			$FN_RTime_Core = StringMid($FN_RTime,1,StringLen($FN_RTime)-9)
			$FN_RTime_Precision = StringRight($FN_RTime,8)
		Else
			$FN_RTime_Core = $FN_RTime
		EndIf
		;
		$FN_AllocSize = StringMid($MFTEntry, $FN_Offset + 128, 16)
		$FN_AllocSize = Dec(_SwapEndian($FN_AllocSize),2)
		$FN_RealSize = StringMid($MFTEntry, $FN_Offset + 144, 16)
		$FN_RealSize = Dec(_SwapEndian($FN_RealSize),2)
		$FN_Flags = StringMid($MFTEntry, $FN_Offset + 160, 8)
		$FN_Flags = _SwapEndian($FN_Flags)
		$FN_Flags = _File_Permissions("0x" & $FN_Flags)
		$FN_EASize = StringMid($MFTEntry, $FN_Offset + 168, 8)
		$FN_EASize = Dec(_SwapEndian($FN_EASize),2)
		$FN_NameLen = StringMid($MFTEntry, $FN_Offset + 176, 2)
		$FN_NameLen = Dec($FN_NameLen)
		$FN_NameType = StringMid($MFTEntry, $FN_Offset + 178, 2)
		Select
			Case $FN_NameType = '00'
				$FN_NameType = 'POSIX'
			Case $FN_NameType = '01'
				$FN_NameType = 'WIN32'
			Case $FN_NameType = '02'
				$FN_NameType = 'DOS'
			Case $FN_NameType = '03'
				$FN_NameType = 'DOS+WIN32'
			Case Else
				$FN_NameType = 'UNKNOWN'
		EndSelect
		$FN_Name = StringMid($MFTEntry, $FN_Offset + 180, $FN_NameLen*4)
		$FN_Name = BinaryToString("0x"&$FN_Name,2)
	EndIf
	If $FN_Number = 2 Then
		$FN_ParentRefNo_2 = StringMid($MFTEntry, $FN_Offset + 48, 12)
		$FN_ParentRefNo_2 = Dec(_SwapEndian($FN_ParentRefNo_2),2)
		$FN_ParentSeqNo_2 = StringMid($MFTEntry, $FN_Offset + 60, 4)
		$FN_ParentSeqNo_2 = Dec(_SwapEndian($FN_ParentSeqNo_2),2)
;		$FN_CTime_2 = StringMid($MFTEntry, $FN_Offset + 64, 16)
;		$FN_CTime_2 = _SwapEndian($FN_CTime_2)
;		$FN_CTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime_2)
;		$FN_CTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_CTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_CTime_2 = $FN_CTime_2 & ":" & _FillZero(StringRight($FN_CTime_2_tmp, 4))
		;
		$FN_CTime_2 = StringMid($MFTEntry, $FN_Offset + 64, 16)
		$FN_CTime_2 = _SwapEndian($FN_CTime_2)
		$FN_CTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime_2)
		$FN_CTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_CTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_CTime_2 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_CTime_2_Core = StringMid($FN_CTime_2,1,StringLen($FN_CTime_2)-4)
			$FN_CTime_2_Precision = StringRight($FN_CTime_2,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_CTime_2 = $FN_CTime_2 & $PrecisionSeparator2 & _FillZero(StringRight($FN_CTime_2_tmp, 4))
			$FN_CTime_2_Core = StringMid($FN_CTime_2,1,StringLen($FN_CTime_2)-9)
			$FN_CTime_2_Precision = StringRight($FN_CTime_2,8)
		Else
			$FN_CTime_2_Core = $FN_CTime_2
		EndIf
		;
;		$FN_ATime_2 = StringMid($MFTEntry, $FN_Offset + 80, 16)
;		$FN_ATime_2 = _SwapEndian($FN_ATime_2)
;		$FN_ATime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime_2)
;		$FN_ATime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_ATime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_ATime_2 = $FN_ATime_2 & ":" & _FillZero(StringRight($FN_ATime_2_tmp, 4))
		;
		$FN_ATime_2 = StringMid($MFTEntry, $FN_Offset + 80, 16)
		$FN_ATime_2 = _SwapEndian($FN_ATime_2)
		$FN_ATime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime_2)
		$FN_ATime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_ATime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_ATime_2 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_ATime_2_Core = StringMid($FN_ATime_2,1,StringLen($FN_ATime_2)-4)
			$FN_ATime_2_Precision = StringRight($FN_ATime_2,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_ATime_2 = $FN_ATime_2 & $PrecisionSeparator2 & _FillZero(StringRight($FN_ATime_2_tmp, 4))
			$FN_ATime_2_Core = StringMid($FN_ATime_2,1,StringLen($FN_ATime_2)-9)
			$FN_ATime_2_Precision = StringRight($FN_ATime_2,8)
		Else
			$FN_ATime_2_Core = $FN_ATime_2
		EndIf
		;
;		$FN_MTime_2 = StringMid($MFTEntry, $FN_Offset + 96, 16)
;		$FN_MTime_2 = _SwapEndian($FN_MTime_2)
;		$FN_MTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime_2)
;		$FN_MTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_MTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_MTime_2 = $FN_MTime_2 & ":" & _FillZero(StringRight($FN_MTime_2_tmp, 4))
		;
		$FN_MTime_2 = StringMid($MFTEntry, $FN_Offset + 96, 16)
		$FN_MTime_2 = _SwapEndian($FN_MTime_2)
		$FN_MTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime_2)
		$FN_MTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_MTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_MTime_2 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_MTime_2_Core = StringMid($FN_MTime_2,1,StringLen($FN_MTime_2)-4)
			$FN_MTime_2_Precision = StringRight($FN_MTime_2,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_MTime_2 = $FN_MTime_2 & $PrecisionSeparator2 & _FillZero(StringRight($FN_MTime_2_tmp, 4))
			$FN_MTime_2_Core = StringMid($FN_MTime_2,1,StringLen($FN_MTime_2)-9)
			$FN_MTime_2_Precision = StringRight($FN_MTime_2,8)
		Else
			$FN_MTime_2_Core = $FN_MTime_2
		EndIf
		;
;		$FN_RTime_2 = StringMid($MFTEntry, $FN_Offset + 112, 16)
;		$FN_RTime_2 = _SwapEndian($FN_RTime_2)
;		$FN_RTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime_2)
;		$FN_RTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_RTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_RTime_2 = $FN_RTime_2 & ":" & _FillZero(StringRight($FN_RTime_2_tmp, 4))
		;
		$FN_RTime_2 = StringMid($MFTEntry, $FN_Offset + 112, 16)
		$FN_RTime_2 = _SwapEndian($FN_RTime_2)
		$FN_RTime_2_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime_2)
		$FN_RTime_2 = _WinTime_UTCFileTimeFormat(Dec($FN_RTime_2,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_RTime_2 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_RTime_2_Core = StringMid($FN_RTime_2,1,StringLen($FN_RTime_2)-4)
			$FN_RTime_2_Precision = StringRight($FN_RTime_2,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_RTime_2 = $FN_RTime_2 & $PrecisionSeparator2 & _FillZero(StringRight($FN_RTime_2_tmp, 4))
			$FN_RTime_2_Core = StringMid($FN_RTime_2,1,StringLen($FN_RTime_2)-9)
			$FN_RTime_2_Precision = StringRight($FN_RTime_2,8)
		Else
			$FN_RTime_2_Core = $FN_RTime_2
		EndIf
		;
		$FN_AllocSize_2 = StringMid($MFTEntry, $FN_Offset + 128, 16)
		$FN_AllocSize_2 = Dec(_SwapEndian($FN_AllocSize_2),2)
		$FN_RealSize_2 = StringMid($MFTEntry, $FN_Offset + 144, 16)
		$FN_RealSize_2 = Dec(_SwapEndian($FN_RealSize_2),2)
		$FN_Flags_2 = StringMid($MFTEntry, $FN_Offset + 160, 8)
		$FN_Flags_2 = _SwapEndian($FN_Flags_2)
		$FN_Flags_2 = _File_Permissions("0x" & $FN_Flags_2)
		$FN_EASize_2 = StringMid($MFTEntry, $FN_Offset + 168, 8)
		$FN_EASize_2 = Dec(_SwapEndian($FN_EASize_2),2)
		$FN_NameLen_2 = StringMid($MFTEntry, $FN_Offset + 176, 2)
		$FN_NameLen_2 = Dec($FN_NameLen_2)
		$FN_NameType_2 = StringMid($MFTEntry, $FN_Offset + 178, 2)
		Select
			Case $FN_NameType_2 = '00'
				$FN_NameType_2 = 'POSIX'
			Case $FN_NameType_2 = '01'
				$FN_NameType_2 = 'WIN32'
			Case $FN_NameType_2 = '02'
				$FN_NameType_2 = 'DOS'
			Case $FN_NameType_2 = '03'
				$FN_NameType_2 = 'DOS+WIN32'
			Case Else
				$FN_NameType_2 = 'UNKNOWN'
		EndSelect
		$FN_Name_2 = StringMid($MFTEntry, $FN_Offset + 180, $FN_NameLen_2*4)
		$FN_Name_2 = BinaryToString("0x"&$FN_Name_2,2)
	EndIf
	If Not $DoDefaultAll Then Return
	If $FN_Number = 3 Then
		$FN_ParentRefNo_3 = StringMid($MFTEntry, $FN_Offset + 48, 12)
		$FN_ParentRefNo_3 = Dec(_SwapEndian($FN_ParentRefNo_3),2)
		$FN_ParentSeqNo_3 = StringMid($MFTEntry, $FN_Offset + 60, 4)
		$FN_ParentSeqNo_3 = Dec(_SwapEndian($FN_ParentSeqNo_3),2)
;		$FN_CTime_3 = StringMid($MFTEntry, $FN_Offset + 64, 16)
;		$FN_CTime_3 = _SwapEndian($FN_CTime_3)
;		$FN_CTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime_3)
;		$FN_CTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_CTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_CTime_3 = $FN_CTime_3 & ":" & _FillZero(StringRight($FN_CTime_3_tmp, 4))
		;
		$FN_CTime_3 = StringMid($MFTEntry, $FN_Offset + 64, 16)
		$FN_CTime_3 = _SwapEndian($FN_CTime_3)
		$FN_CTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_CTime_3)
		$FN_CTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_CTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_CTime_3 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_CTime_3_Core = StringMid($FN_CTime_3,1,StringLen($FN_CTime_3)-4)
			$FN_CTime_3_Precision = StringRight($FN_CTime_3,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_CTime_3 = $FN_CTime_3 & $PrecisionSeparator2 & _FillZero(StringRight($FN_CTime_3_tmp, 4))
			$FN_CTime_3_Core = StringMid($FN_CTime_3,1,StringLen($FN_CTime_3)-9)
			$FN_CTime_3_Precision = StringRight($FN_CTime_3,8)
		Else
			$FN_CTime_3_Core = $FN_CTime_3
		EndIf
		;
;		$FN_ATime_3 = StringMid($MFTEntry, $FN_Offset + 80, 16)
;		$FN_ATime_3 = _SwapEndian($FN_ATime_3)
;		$FN_ATime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime_3)
;		$FN_ATime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_ATime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_ATime_3 = $FN_ATime_3 & ":" & _FillZero(StringRight($FN_ATime_3_tmp, 4))
		;
		$FN_ATime_3 = StringMid($MFTEntry, $FN_Offset + 80, 16)
		$FN_ATime_3 = _SwapEndian($FN_ATime_3)
		$FN_ATime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_ATime_3)
		$FN_ATime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_ATime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_ATime_3 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_ATime_3_Core = StringMid($FN_ATime_3,1,StringLen($FN_ATime_3)-4)
			$FN_ATime_3_Precision = StringRight($FN_ATime_3,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_ATime_3 = $FN_ATime_3 & $PrecisionSeparator2 & _FillZero(StringRight($FN_ATime_3_tmp, 4))
			$FN_ATime_3_Core = StringMid($FN_ATime_3,1,StringLen($FN_ATime_3)-9)
			$FN_ATime_3_Precision = StringRight($FN_ATime_3,8)
		Else
			$FN_ATime_3_Core = $FN_ATime_3
		EndIf
		;
;		$FN_MTime_3 = StringMid($MFTEntry, $FN_Offset + 96, 16)
;		$FN_MTime_3 = _SwapEndian($FN_MTime_3)
;		$FN_MTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime_3)
;		$FN_MTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_MTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_MTime_3 = $FN_MTime_3 & ":" & _FillZero(StringRight($FN_MTime_3_tmp, 4))
		;
		$FN_MTime_3 = StringMid($MFTEntry, $FN_Offset + 96, 16)
		$FN_MTime_3 = _SwapEndian($FN_MTime_3)
		$FN_MTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_MTime_3)
		$FN_MTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_MTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_MTime_3 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_MTime_3_Core = StringMid($FN_MTime_3,1,StringLen($FN_MTime_3)-4)
			$FN_MTime_3_Precision = StringRight($FN_MTime_3,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_MTime_3 = $FN_MTime_3 & $PrecisionSeparator2 & _FillZero(StringRight($FN_MTime_3_tmp, 4))
			$FN_MTime_3_Core = StringMid($FN_MTime_3,1,StringLen($FN_MTime_3)-9)
			$FN_MTime_3_Precision = StringRight($FN_MTime_3,8)
		Else
			$FN_MTime_3_Core = $FN_MTime_3
		EndIf
		;
;		$FN_RTime_3 = StringMid($MFTEntry, $FN_Offset + 112, 16)
;		$FN_RTime_3 = _SwapEndian($FN_RTime_3)
;		$FN_RTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime_3)
;		$FN_RTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_RTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
;		$FN_RTime_3 = $FN_RTime_3 & ":" & _FillZero(StringRight($FN_RTime_3_tmp, 4))
		;
		$FN_RTime_3 = StringMid($MFTEntry, $FN_Offset + 112, 16)
		$FN_RTime_3 = _SwapEndian($FN_RTime_3)
		$FN_RTime_3_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $FN_RTime_3)
		$FN_RTime_3 = _WinTime_UTCFileTimeFormat(Dec($FN_RTime_3,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$FN_RTime_3 = $TimestampErrorVal
		ElseIf $TimestampPrecision = 2 Then
			$FN_RTime_3_Core = StringMid($FN_RTime_3,1,StringLen($FN_RTime_3)-4)
			$FN_RTime_3_Precision = StringRight($FN_RTime_3,3)
		ElseIf $TimestampPrecision = 3 Then
			$FN_RTime_3 = $FN_RTime_3 & $PrecisionSeparator2 & _FillZero(StringRight($FN_RTime_3_tmp, 4))
			$FN_RTime_3_Core = StringMid($FN_RTime_3,1,StringLen($FN_RTime_3)-9)
			$FN_RTime_3_Precision = StringRight($FN_RTime_3,8)
		Else
			$FN_RTime_3_Core = $FN_RTime_3
		EndIf
		;
		$FN_AllocSize_3 = StringMid($MFTEntry, $FN_Offset + 128, 16)
		$FN_AllocSize_3 = Dec(_SwapEndian($FN_AllocSize_3),2)
		$FN_RealSize_3 = StringMid($MFTEntry, $FN_Offset + 144, 16)
		$FN_RealSize_3 = Dec(_SwapEndian($FN_RealSize_3),2)
		$FN_Flags_3 = StringMid($MFTEntry, $FN_Offset + 160, 8)
		$FN_Flags_3 = _SwapEndian($FN_Flags_3)
		$FN_Flags_3 = _File_Permissions("0x" & $FN_Flags_3)
		$FN_EASize_3 = StringMid($MFTEntry, $FN_Offset + 168, 8)
		$FN_EASize_3 = Dec(_SwapEndian($FN_EASize_3),2)
		$FN_NameLen_3 = StringMid($MFTEntry, $FN_Offset + 176, 2)
		$FN_NameLen_3 = Dec($FN_NameLen_3)
		$FN_NameType_3 = StringMid($MFTEntry, $FN_Offset + 178, 2)
		Select
			Case $FN_NameType_3 = '00'
				$FN_NameType_3 = 'POSIX'
			Case $FN_NameType_3 = '01'
				$FN_NameType_3 = 'WIN32'
			Case $FN_NameType_3 = '02'
				$FN_NameType_3 = 'DOS'
			Case $FN_NameType_3 = '03'
				$FN_NameType_3 = 'DOS+WIN32'
			Case Else
				$FN_NameType_3 = 'UNKNOWN'
		EndSelect
		$FN_Name_3 = StringMid($MFTEntry, $FN_Offset + 180, $FN_NameLen_3*4)
		$FN_Name_3 = BinaryToString("0x"&$FN_Name_3,2)
	EndIf
	Return
EndFunc   ;==>_Get_FileName

Func _Get_ObjectID($MFTEntry,$OBJECTID_Offset,$OBJECTID_Size)
	$GUID_ObjectID = StringMid($MFTEntry,$OBJECTID_Offset+48,32)
	$GUID_ObjectID = _HexToGuidStr($GUID_ObjectID,1)
	Select
		Case $OBJECTID_Size - 24 = 16
			$GUID_BirthVolumeID = "NOT PRESENT"
			$GUID_BirthObjectID = "NOT PRESENT"
			$GUID_BirthDomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 32
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			$GUID_BirthObjectID = "NOT PRESENT"
			$GUID_BirthDomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 48
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			$GUID_BirthObjectID = StringMid($MFTEntry,$OBJECTID_Offset+112,32)
			$GUID_BirthObjectID = _HexToGuidStr($GUID_BirthObjectID,1)
			$GUID_BirthDomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 64
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			$GUID_BirthObjectID = StringMid($MFTEntry,$OBJECTID_Offset+112,32)
			$GUID_BirthObjectID = _HexToGuidStr($GUID_BirthObjectID,1)
			$GUID_BirthDomainID = StringMid($MFTEntry,$OBJECTID_Offset+144,32)
			$GUID_BirthDomainID = _HexToGuidStr($GUID_BirthDomainID,1)
		Case Else
			ConsoleWrite("Error: The $OBJECT_ID size was unexpected." & @crlf)
	EndSelect
EndFunc

Func _HexToGuidStr($input,$mode)
	;{4b-2b-2b-2b-6b}
	Local $OutStr
	If Not StringLen($input) = 32 Then Return $input
	If $mode Then $OutStr = "{"
	$OutStr &= _SwapEndian(StringMid($input,1,8)) & "-"
	$OutStr &= _SwapEndian(StringMid($input,9,4)) & "-"
	$OutStr &= _SwapEndian(StringMid($input,13,4)) & "-"
	$OutStr &= StringMid($input,17,4) & "-"
	$OutStr &= StringMid($input,21,12)
	If $mode Then $OutStr &= "}"
	Return $OutStr
EndFunc

Func _Get_SecurityDescriptor()
;	ConsoleWrite("Get_SecurityDescriptor Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_SecurityDescriptor

Func _Get_VolumeName($MFTEntry, $VOLUME_NAME_Offset, $VOLUME_NAME_Size)
	If $VOLUME_NAME_Size - 24 > 0 Then
		$VOLUME_NAME_NAME = StringMid($MFTEntry, $VOLUME_NAME_Offset + 48, ($VOLUME_NAME_Size - 24) * 2)
		$VOLUME_NAME_NAME = BinaryToString("0x"&$VOLUME_NAME_NAME,2)
		Return
	EndIf
	$VOLUME_NAME_NAME = "EMPTY"
	Return
EndFunc   ;==>_Get_VolumeName

Func _Get_VolumeInformation($MFTEntry, $VOLUME_INFO_Offset, $VOLUME_INFO_Size)
	$VOL_INFO_NTFS_VERSION = Dec(StringMid($MFTEntry, $VOLUME_INFO_Offset + 64, 2)) & "," & Dec(StringMid($MFTEntry, $VOLUME_INFO_Offset + 66, 2))
	$VOL_INFO_FLAGS = StringMid($MFTEntry, $VOLUME_INFO_Offset + 68, 4)
	$VOL_INFO_FLAGS = _SwapEndian($VOL_INFO_FLAGS)
	$VOL_INFO_FLAGS = _VolInfoFlag("0x" & $VOL_INFO_FLAGS)
	Return
EndFunc   ;==>_Get_VolumeInformation

Func _Get_Data($MFTEntry, $DT_Offset, $DT_Size, $DT_Number)
	If $DT_Number = 1 Then
		$DT_NonResidentFlag = StringMid($MFTEntry, $DT_Offset + 16, 2)
		$DT_NameLength = Dec(StringMid($MFTEntry, $DT_Offset + 18, 2))
		$DT_NameRelativeOffset = StringMid($MFTEntry, $DT_Offset + 20, 4)
		$DT_NameRelativeOffset = Dec(_SwapEndian($DT_NameRelativeOffset),2)
		$DT_Flags = StringMid($MFTEntry, $DT_Offset + 24, 4)
		$DT_Flags = _SwapEndian($DT_Flags)
		$DT_Flags = _AttribHeaderFlags("0x" & $DT_Flags)
		If $DT_NameLength > 0 Then
			$DT_NameSpace = $DT_NameLength - 1
			$DT_Name = StringMid($MFTEntry, $DT_Offset + ($DT_NameRelativeOffset * 2), $DT_NameLength*4)
			$DT_Name = BinaryToString("0x"&$DT_Name,2)
		EndIf
		If $DT_NonResidentFlag = '01' Then
			$DT_StartVCN = StringMid($MFTEntry, $DT_Offset + 32, 16)
			$DT_StartVCN = Dec(_SwapEndian($DT_StartVCN),2)
			$DT_LastVCN = StringMid($MFTEntry, $DT_Offset + 48, 16)
			$DT_LastVCN = Dec(_SwapEndian($DT_LastVCN),2)
			$DT_VCNs = $DT_LastVCN - $DT_StartVCN
			$DT_ComprUnitSize = StringMid($MFTEntry, $DT_Offset + 68, 4)
			$DT_ComprUnitSize = Dec(_SwapEndian($DT_ComprUnitSize),2)
			$DT_AllocSize = StringMid($MFTEntry, $DT_Offset + 80, 16)
			$DT_AllocSize = Dec(_SwapEndian($DT_AllocSize),2)
			$DT_RealSize = StringMid($MFTEntry, $DT_Offset + 96, 16)
			$DT_RealSize = Dec(_SwapEndian($DT_RealSize),2)
			$FileSizeBytes = $DT_RealSize
			$DT_InitStreamSize = StringMid($MFTEntry, $DT_Offset + 112, 16)
			$DT_InitStreamSize = Dec(_SwapEndian($DT_InitStreamSize),2)
		ElseIf $DT_NonResidentFlag = '00' Then
			$DT_LengthOfAttribute = StringMid($MFTEntry, $DT_Offset + 32, 8)
			$DT_LengthOfAttribute = Dec(_SwapEndian($DT_LengthOfAttribute),2)
			$FileSizeBytes = $DT_LengthOfAttribute
			$DT_OffsetToAttribute = StringMid($MFTEntry, $DT_Offset + 40, 4)
			$DT_OffsetToAttribute = Dec(_SwapEndian($DT_OffsetToAttribute),2)
			$DT_IndexedFlag = Dec(StringMid($MFTEntry, $DT_Offset + 44, 2))
		EndIf
	EndIf
	If $DT_Number = 2 Then
		$DT_NonResidentFlag_2 = StringMid($MFTEntry, $DT_Offset + 16, 2)
		$DT_NameLength_2 = Dec(StringMid($MFTEntry, $DT_Offset + 18, 2))
		$DT_NameRelativeOffset_2 = StringMid($MFTEntry, $DT_Offset + 20, 4)
		$DT_NameRelativeOffset_2 = Dec(_SwapEndian($DT_NameRelativeOffset_2),2)
		$DT_Flags_2 = StringMid($MFTEntry, $DT_Offset + 24, 4)
		$DT_Flags_2 = _SwapEndian($DT_Flags_2)
		$DT_Flags_2 = _AttribHeaderFlags("0x" & $DT_Flags_2)
		If $DT_NameLength_2 > 0 Then
			$DT_NameSpace_2 = $DT_NameLength_2 - 1
			$DT_Name_2 = StringMid($MFTEntry, $DT_Offset + ($DT_NameRelativeOffset_2 * 2), $DT_NameLength_2*4)
			$DT_Name_2 = BinaryToString("0x"&$DT_Name_2,2)
		EndIf
		If $DT_NonResidentFlag_2 = '01' Then
			$DT_StartVCN_2 = StringMid($MFTEntry, $DT_Offset + 32, 16)
			$DT_StartVCN_2 = Dec(_SwapEndian($DT_StartVCN_2),2)
			$DT_LastVCN_2 = StringMid($MFTEntry, $DT_Offset + 48, 16)
			$DT_LastVCN_2 = Dec(_SwapEndian($DT_LastVCN_2),2)
			$DT_VCNs_2 = $DT_LastVCN_2 - $DT_StartVCN_2
			$DT_ComprUnitSize_2 = StringMid($MFTEntry, $DT_Offset + 68, 4)
			$DT_ComprUnitSize_2 = Dec(_SwapEndian($DT_ComprUnitSize_2),2)
			$DT_AllocSize_2 = StringMid($MFTEntry, $DT_Offset + 80, 16)
			$DT_AllocSize_2 = Dec(_SwapEndian($DT_AllocSize_2),2)
			$DT_RealSize_2 = StringMid($MFTEntry, $DT_Offset + 96, 16)
			$DT_RealSize_2 = Dec(_SwapEndian($DT_RealSize_2),2)
			$DT_InitStreamSize_2 = StringMid($MFTEntry, $DT_Offset + 112, 16)
			$DT_InitStreamSize_2 = Dec(_SwapEndian($DT_InitStreamSize_2),2)
		ElseIf $DT_NonResidentFlag_2 = '00' Then
			$DT_LengthOfAttribute_2 = StringMid($MFTEntry, $DT_Offset + 32, 8)
			$DT_LengthOfAttribute_2 = Dec(_SwapEndian($DT_LengthOfAttribute_2),2)
			$DT_OffsetToAttribute_2 = StringMid($MFTEntry, $DT_Offset + 40, 4)
			$DT_OffsetToAttribute_2 = Dec(_SwapEndian($DT_OffsetToAttribute_2),2)
			$DT_IndexedFlag_2 = Dec(StringMid($MFTEntry, $DT_Offset + 44, 2))
		EndIf
	EndIf
	If $DT_Number = 3 Then
		$DT_NonResidentFlag_3 = StringMid($MFTEntry, $DT_Offset + 16, 2)
		$DT_NameLength_3 = Dec(StringMid($MFTEntry, $DT_Offset + 18, 2))
		$DT_NameRelativeOffset_3 = StringMid($MFTEntry, $DT_Offset + 20, 4)
		$DT_NameRelativeOffset_3 = Dec(_SwapEndian($DT_NameRelativeOffset_3),2)
		$DT_Flags_3 = StringMid($MFTEntry, $DT_Offset + 24, 4)
		$DT_Flags_3 = _SwapEndian($DT_Flags_3)
		$DT_Flags_3 = _AttribHeaderFlags("0x" & $DT_Flags_3)
		If $DT_NameLength_3 > 0 Then
			$DT_NameSpace_3 = $DT_NameLength_3 - 1
			$DT_Name_3 = StringMid($MFTEntry, $DT_Offset + ($DT_NameRelativeOffset_3 * 2), $DT_NameLength_3*4)
			$DT_Name_3 = BinaryToString("0x"&$DT_Name_3,2)
		EndIf
		If $DT_NonResidentFlag_3 = '01' Then
			$DT_StartVCN_3 = StringMid($MFTEntry, $DT_Offset + 32, 16)
			$DT_StartVCN_3 = Dec(_SwapEndian($DT_StartVCN_3),2)
			$DT_LastVCN_3 = StringMid($MFTEntry, $DT_Offset + 48, 16)
			$DT_LastVCN_3 = Dec(_SwapEndian($DT_LastVCN_3),2)
			$DT_VCNs_3 = $DT_LastVCN_3 - $DT_StartVCN_3
			$DT_ComprUnitSize_3 = StringMid($MFTEntry, $DT_Offset + 68, 4)
			$DT_ComprUnitSize_3 = Dec(_SwapEndian($DT_ComprUnitSize_3),2)
			$DT_AllocSize_3 = StringMid($MFTEntry, $DT_Offset + 80, 16)
			$DT_AllocSize_3 = Dec(_SwapEndian($DT_AllocSize_3),2)
			$DT_RealSize_3 = StringMid($MFTEntry, $DT_Offset + 96, 16)
			$DT_RealSize_3 = Dec(_SwapEndian($DT_RealSize_3),2)
			$DT_InitStreamSize_3 = StringMid($MFTEntry, $DT_Offset + 112, 16)
			$DT_InitStreamSize_3 = Dec(_SwapEndian($DT_InitStreamSize_3),2)
		ElseIf $DT_NonResidentFlag_3 = '00' Then
			$DT_LengthOfAttribute_3 = StringMid($MFTEntry, $DT_Offset + 32, 8)
			$DT_LengthOfAttribute_3 = Dec(_SwapEndian($DT_LengthOfAttribute_3),2)
			$DT_OffsetToAttribute_3 = StringMid($MFTEntry, $DT_Offset + 40, 4)
			$DT_OffsetToAttribute_3 = Dec(_SwapEndian($DT_OffsetToAttribute_3),2)
			$DT_IndexedFlag_3 = Dec(StringMid($MFTEntry, $DT_Offset + 44, 2))
		EndIf
	EndIf
EndFunc   ;==>_Get_Data

Func _Get_IndexRoot()
;	ConsoleWrite("Get_IndexRoot Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_IndexRoot

Func _Get_IndexAllocation()
;	ConsoleWrite("Get_IndexAllocation Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_IndexAllocation

Func _Get_Bitmap()
;	ConsoleWrite("Get_Bitmap Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_Bitmap

Func _Get_ReparsePoint()
;	ConsoleWrite("Get_ReparsePoint Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_ReparsePoint

Func _Get_EaInformation()
;	ConsoleWrite("Get_EaInformation Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_EaInformation

Func _Get_Ea()
;	ConsoleWrite("Get_Ea Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_Ea

Func _Get_PropertySet()
;	ConsoleWrite("Get_PropertySet Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_PropertySet

Func _Get_LoggedUtilityStream()
;	ConsoleWrite("Get_LoggedUtilityStream Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_LoggedUtilityStream

Func _ClearVar()
	$SI_ON = 0
	$AL_ON = 0
	$FN_ON = 0
	$OI_ON = 0
	$SD_ON = 0
	$VN_ON = 0
	$VI_ON = 0
	$DT_ON = 0
	$IR_ON = 0
	$IA_ON = 0
	$BITMAP_ON = 0
	$RP_ON = 0
	$EAI_ON = 0
	$EA_ON = 0
	$PS_ON = 0
	$LUS_ON = 0
	$SI_CTime = ""
	$SI_ATime = ""
	$SI_MTime = ""
	$SI_RTime = ""
	$SI_FilePermission = ""
	$SI_Quota = ""
	$SI_USN = ""
	$FN_CTime = ""
	$FN_ATime = ""
	$FN_MTime = ""
	$FN_RTime = ""
	$FN_AllocSize = ""
	$FN_RealSize = ""
	$FN_EaSize = ""
	$FN_Flags = ""
	$FN_Name = ""
	$FN_FileName = ""
	$DT_NameLength = ""
	$DT_NameRelativeOffset = ""
	$DT_Flags = ""
	$DT_NameSpace = ""
	$DT_Name = ""
	$DT_VCNs = ""
	$DT_NonResidentFlag = ""
	$DT_AllocSize = ""
	$DT_RealSize = ""
	$DT_InitStreamSize = ""
	$DT_NonResidentFlag_2 = ""
	$DT_NameLength_2 = ""
	$DT_NameRelativeOffset_2 = ""
	$DT_Flags_2 = ""
	$DT_NameSpace_2 = ""
	$DT_Name_2 = ""
	$DT_StartVCN_2 = ""
	$DT_LastVCN_2 = ""
	$DT_VCNs_2 = ""
	$DT_AllocSize_2 = ""
	$DT_RealSize_2 = ""
	$DT_InitStreamSize_2 = ""
	$DT_NonResidentFlag_3 = ""
	$DT_NameLength_3 = ""
	$DT_NameRelativeOffset_3 = ""
	$DT_Flags_3 = ""
	$DT_NameSpace_3 = ""
	$DT_Name_3 = ""
	$DT_StartVCN_3 = ""
	$DT_LastVCN_3 = ""
	$DT_VCNs_3 = ""
	$DT_AllocSize_3 = ""
	$DT_RealSize_3 = ""
	$DT_InitStreamSize_3 = ""
	$RecordSlackSpace = ""
	$FN_NameType = ""
	$FN_CTime_2 = ""
	$FN_ATime_2 = ""
	$FN_MTime_2 = ""
	$FN_RTime_2 = ""
	$FN_AllocSize_2 = ""
	$FN_RealSize_2 = ""
	$FN_EaSize_2 = ""
	$FN_Flags_2 = ""
	$FN_NameLen_2 = ""
	$FN_Name_2 = ""
	$FN_NameType_2 = ""
	$FN_CTime_3 = ""
	$FN_ATime_3 = ""
	$FN_MTime_3 = ""
	$FN_RTime_3 = ""
	$FN_AllocSize_3 = ""
	$FN_RealSize_3 = ""
	$FN_EASize_3 = ""
	$FN_Flags_3 = ""
	$FN_NameLen_3 = ""
	$FN_Name_3 = ""
	$FN_NameType_3 = ""
	$FN_ParentRefNo = ""
	$FN_ParentSeqNo = ""
	$FN_ParentRefNo_2 = ""
	$FN_ParentSeqNo_2 = ""
	$FN_ParentRefNo_3 = ""
	$FN_ParentSeqNo_3 = ""
	$FN_ParentRefNo_4 = ""
	$FN_ParentSeqNo_4 = ""
	$DT_LengthOfAttribute = ""
	$DT_OffsetToAttribute = ""
	$DT_IndexedFlag = ""
	$DT_LengthOfAttribute_2 = ""
	$DT_OffsetToAttribute_2 = ""
	$DT_IndexedFlag_2 = ""
	$DT_LengthOfAttribute_3 = ""
	$DT_OffsetToAttribute_3 = ""
	$DT_IndexedFlag_3 = ""
	$DT_ComprUnitSize = ""
	$DT_ComprUnitSize_2 = ""
	$DT_ComprUnitSize_3 = ""
	$MSecTest = ""
	$CTimeTest = ""
	$SI_MaxVersions = ""
	$SI_VersionNumber = ""
	$SI_ClassID = ""
	$SI_OwnerID = ""
	$SI_SecurityID = ""
	$SI_HEADER_Flags = ""
	$GUID_ObjectID = ""
	$GUID_BirthVolumeID = ""
	$GUID_BirthObjectID = ""
	$GUID_BirthDomainID = ""
	$VOLUME_NAME_NAME = ""
	$VOL_INFO_NTFS_VERSION = ""
	$VOL_INFO_FLAGS = ""
	$DT_Number = ""
	$ADS = ""
	$FileSizeBytes = ""
	$SI_CTime_tmp = ""
	$SI_ATime_tmp = ""
	$SI_MTime_tmp = ""
	$SI_RTime_tmp = ""
	$FN_CTime_tmp = ""
	$FN_ATime_tmp = ""
	$FN_MTime_tmp = ""
	$FN_RTime_tmp = ""
	$FN_CTime_2_tmp = ""
	$FN_ATime_2_tmp = ""
	$FN_MTime_2_tmp = ""
	$FN_RTime_2_tmp = ""
	$IntegrityCheck = ""
	$HDR_HardLinkCount = ""
	$HDR_BaseRecSeqNo = ""
	$RecordActive = ""
	$HDR_Flags = ""
	$HDR_LSN = ""
	$HDR_SequenceNo = ""
	$HDR_RecRealSize = ""
	$HDR_RecAllocSize = ""
	$HDR_BaseRecord = ""
	$HDR_NextAttribID = ""
	$HDR_MFTREcordNumber = ""
	$style = ""
	If $DoSplitCsv Then
		$SI_CTime_Core = ""
		$SI_ATime_Core = ""
		$SI_MTime_Core = ""
		$SI_RTime_Core = ""
		$SI_CTime_Precision = ""
		$SI_ATime_Precision = ""
		$SI_MTime_Precision = ""
		$SI_RTime_Precision = ""
		$FN_CTime_Core = ""
		$FN_ATime_Core = ""
		$FN_MTime_Core = ""
		$FN_RTime_Core = ""
		$FN_CTime_Precision = ""
		$FN_ATime_Precision = ""
		$FN_MTime_Precision = ""
		$FN_RTime_Precision = ""
		$FN_CTime_2_Core = ""
		$FN_ATime_2_Core = ""
		$FN_MTime_2_Core = ""
		$FN_RTime_2_Core = ""
		$FN_CTime_2_Precision = ""
		$FN_ATime_2_Precision = ""
		$FN_MTime_2_Precision = ""
		$FN_RTime_2_Precision = ""
		$FN_CTime_3_Core = ""
		$FN_ATime_3_Core = ""
		$FN_MTime_3_Core = ""
		$FN_RTime_3_Core = ""
		$FN_CTime_3_Precision = ""
		$FN_ATime_3_Precision = ""
		$FN_MTime_3_Precision = ""
		$FN_RTime_3_Precision = ""
	EndIf
EndFunc   ;==>_ClearVar

Func _Test_MilliSec($timestamp)
	If StringRight($timestamp, 8) = '000:0000' Then
		;If StringRight($timestamp,4) = '000' Then
		$MSecTest = 1
	Else
		$MSecTest = 0
	EndIf
	Return $MSecTest
EndFunc   ;==>_Test_MilliSec

Func _Test_SI2FN_CTime($SI_CTime, $FN_CTime)
	If $SI_CTime < $FN_CTime Then
		$CTimeTest = 1
	Else
		$CTimeTest = 0
	EndIf
	Return $CTimeTest
EndFunc   ;==>_Test_SI2FN_CTime

Func _File_Permissions($FPinput)
	Local $FPoutput = ""
	If BitAND($FPinput, 0x0001) Then $FPoutput &= 'read_only+'
	If BitAND($FPinput, 0x0002) Then $FPoutput &= 'hidden+'
	If BitAND($FPinput, 0x0004) Then $FPoutput &= 'system+'
	If BitAND($FPinput, 0x0020) Then $FPoutput &= 'archive+'
	If BitAND($FPinput, 0x0040) Then $FPoutput &= 'device+'
	If BitAND($FPinput, 0x0080) Then $FPoutput &= 'normal+'
	If BitAND($FPinput, 0x0100) Then $FPoutput &= 'temporary+'
	If BitAND($FPinput, 0x0200) Then $FPoutput &= 'sparse_file+'
	If BitAND($FPinput, 0x0400) Then $FPoutput &= 'reparse_point+'
	If BitAND($FPinput, 0x0800) Then $FPoutput &= 'compressed+'
	If BitAND($FPinput, 0x1000) Then $FPoutput &= 'offline+'
	If BitAND($FPinput, 0x2000) Then $FPoutput &= 'not_indexed+'
	If BitAND($FPinput, 0x4000) Then $FPoutput &= 'encrypted+'
	If BitAND($FPinput, 0x10000000) Then $FPoutput &= 'directory+'
	If BitAND($FPinput, 0x20000000) Then $FPoutput &= 'index_view+'
	$FPoutput = StringTrimRight($FPoutput, 1)
	Return $FPoutput
EndFunc   ;==>_File_Permissions

Func _AttribHeaderFlags($AHinput)
	Local $AHoutput = ""
	If BitAND($AHinput, 0x0001) Then $AHoutput &= 'COMPRESSED+'
	If BitAND($AHinput, 0x4000) Then $AHoutput &= 'ENCRYPTED+'
	If BitAND($AHinput, 0x8000) Then $AHoutput &= 'SPARSE+'
	$AHoutput = StringTrimRight($AHoutput, 1)
	Return $AHoutput
EndFunc   ;==>_AttribHeaderFlags

Func _FileRecordFlag($FRFinput) ;Turns out to be problematic to use BitAND with these values
	Local $FRFoutput = ""
	If BitAND($FRFinput, 0x0000) Then $FRFoutput &= 'FILE_DELETE+'
	If BitAND($FRFinput, 0x0001) Then $FRFoutput &= 'FILE+'
	If BitAND($FRFinput, 0x0003) Then $FRFoutput &= 'DIRECTORY+'
	If BitAND($FRFinput, 0x0002) Then $FRFoutput &= 'DIRECTORY_DELETE+'
	If BitAND($FRFinput, 0x0004) Then $FRFoutput &= 'UNKNOWN1+'
	If BitAND($FRFinput, 0x0008) Then $FRFoutput &= 'UNKNOWN2+'
	$FRFoutput = StringTrimRight($FRFoutput, 1)
	Return $FRFoutput
EndFunc   ;==>_FileRecordFlag

Func _VolInfoFlag($VIFinput)
	Local $VIFoutput = ""
	If BitAND($VIFinput, 0x0001) Then $VIFoutput &= 'Dirty+'
	If BitAND($VIFinput, 0x0002) Then $VIFoutput &= 'Resize_LogFile+'
	If BitAND($VIFinput, 0x0004) Then $VIFoutput &= 'Upgrade_On_Mount+'
	If BitAND($VIFinput, 0x0008) Then $VIFoutput &= 'Mounted_On_NT4+'
	If BitAND($VIFinput, 0x0010) Then $VIFoutput &= 'Deleted_USN_Underway+'
	If BitAND($VIFinput, 0x0020) Then $VIFoutput &= 'Repair_ObjectIDs+'
	If BitAND($VIFinput, 0x8000) Then $VIFoutput &= 'Modified_By_CHKDSK+'
	$VIFoutput = StringTrimRight($VIFoutput, 1)
	Return $VIFoutput
EndFunc   ;==>_VolInfoFlag

Func _FillZero($inp)
	Local $inplen, $out, $tmp = ""
	$inplen = StringLen($inp)
	For $i = 1 To 4 - $inplen
		$tmp &= "0"
	Next
	$out = $tmp & $inp
	Return $out
EndFunc   ;==>_FillZero

Func _WriteCSV2()
	If $dol2t Then
;		If $SI_CTime <> "" Then
			FileWriteLine($csv, StringLeft($SI_CTime,10) & $de & StringMid($SI_CTime,12,8) & $de & $UTCconfig & $de & "C" & $de & "MFT" & $de & $HDR_Flags & $de & "File Create" & $de & "" & $de & "" & $de & "SI" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($SI_ATime,10) & $de & StringMid($SI_ATime,12,8) & $de & $UTCconfig & $de & "M" & $de & "MFT" & $de & $HDR_Flags & $de & "File Modified" & $de & "" & $de & "" & $de & "SI" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($SI_MTime,10) & $de & StringMid($SI_MTime,12,8) & $de & $UTCconfig & $de & "B" & $de & "MFT" & $de & $HDR_Flags & $de & "MFT Entry" & $de & "" & $de & "" & $de & "SI" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($SI_RTime,10) & $de & StringMid($SI_RTime,12,8) & $de & $UTCconfig & $de & "A" & $de & "MFT" & $de & $HDR_Flags & $de & "File Last Access" & $de & "" & $de & "" & $de & "SI" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
;		EndIf
		If $FN_CTime <> "" Then
			FileWriteLine($csv, StringLeft($FN_CTime,10) & $de & StringMid($FN_CTime,12,8) & $de & $UTCconfig & $de & "C" & $de & "MFT" & $de & $HDR_Flags & $de & "File Create" & $de & "" & $de & "" & $de & "FN1" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_ATime,10) & $de & StringMid($FN_ATime,12,8) & $de & $UTCconfig & $de & "M" & $de & "MFT" & $de & $HDR_Flags & $de & "File Modified" & $de & "" & $de & "" & $de & "FN1" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_MTime,10) & $de & StringMid($FN_MTime,12,8) & $de & $UTCconfig & $de & "B" & $de & "MFT" & $de & $HDR_Flags & $de & "MFT Entry" & $de & "" & $de & "" & $de & "FN1" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_RTime,10) & $de & StringMid($FN_RTime,12,8) & $de & $UTCconfig & $de & "A" & $de & "MFT" & $de & $HDR_Flags & $de & "File Last Access" & $de & "" & $de & "" & $de & "FN1" & $de & $FN_NamePath & $de & "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
		EndIf
		If $FN_CTime_2 <> "" Then
			FileWriteLine($csv, StringLeft($FN_CTime_2,10) & $de & StringMid($FN_CTime_2,12,8) & $de & $UTCconfig & $de & "C" & $de & "MFT" & $de & $HDR_Flags & $de & "File Create" & $de & "" & $de & "" & $de & "FN2" & $de & $FN_NamePath & $de & "" & $de & $FN_Name_2 & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_ATime_2,10) & $de & StringMid($FN_ATime_2,12,8) & $de & $UTCconfig & $de & "M" & $de & "MFT" & $de & $HDR_Flags & $de & "File Modified" & $de & "" & $de & "" & $de & "FN2" & $de & $FN_NamePath & $de & "" & $de & $FN_Name_2 & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_MTime_2,10) & $de & StringMid($FN_MTime_2,12,8) & $de & $UTCconfig & $de & "B" & $de & "MFT" & $de & $HDR_Flags & $de & "MFT Entry" & $de & "" & $de & "" & $de & "FN2" & $de & $FN_NamePath & $de & "" & $de & $FN_Name_2 & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
			FileWriteLine($csv, StringLeft($FN_RTime_2,10) & $de & StringMid($FN_RTime_2,12,8) & $de & $UTCconfig & $de & "A" & $de & "MFT" & $de & $HDR_Flags & $de & "File Last Access" & $de & "" & $de & "" & $de & "FN2" & $de & $FN_NamePath & $de & "" & $de & $FN_Name_2 & $de & $HDR_MFTREcordNumber & $de & $RecordActive & $de & "" & $de & "" & @CRLF)
		EndIf
	ElseIf $DoBodyfile Then
;		If $SI_CTime <> "" Then
			FileWriteLine($csv, "" & $de & $FN_Name & $de & $HDR_MFTREcordNumber & $de & "" & $de & "" & $de & "" & $de & $FileSizeBytes & $de & StringLeft($SI_ATime,19) & $de & StringLeft($SI_MTime,19) & $de & StringLeft($SI_CTime,19) & $de & StringLeft($SI_RTime,19) & @CRLF)
;		EndIf
	EndIf
EndFunc

Func _WriteCSV2withQuotes()
	If $dol2t Then
;		If $SI_CTime <> "" Then
			FileWriteLine($csv, '"'& StringLeft($SI_CTime,10) &'"'& $de &'"'& StringMid($SI_CTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "C" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Create" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "SI" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($SI_ATime,10) &'"'& $de &'"'& StringMid($SI_ATime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "M" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Modified" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "SI" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($SI_MTime,10) &'"'& $de &'"'& StringMid($SI_MTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "B" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "MFT Entry" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "SI" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($SI_RTime,10) &'"'& $de &'"'& StringMid($SI_RTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "A" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Last Access" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "SI" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
;		EndIf
		If $FN_CTime <> "" Then
			FileWriteLine($csv, '"'& StringLeft($FN_CTime,10) &'"'& $de &'"'& StringMid($FN_CTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "C" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Create" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN1" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_ATime,10) &'"'& $de &'"'& StringMid($FN_ATime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "M" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Modified" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN1" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_MTime,10) &'"'& $de &'"'& StringMid($FN_MTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "B" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "MFT Entry" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN1" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_RTime,10) &'"'& $de &'"'& StringMid($FN_RTime,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "A" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Last Access" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN1" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
		EndIf
		If $FN_CTime_2 <> "" Then
			FileWriteLine($csv, '"'& StringLeft($FN_CTime_2,10) &'"'& $de &'"'& StringMid($FN_CTime_2,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "C" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Create" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN2" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name_2 &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_ATime_2,10) &'"'& $de &'"'& StringMid($FN_ATime_2,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "M" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Modified" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN2" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name_2 &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_MTime_2,10) &'"'& $de &'"'& StringMid($FN_MTime_2,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "B" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "MFT Entry" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN2" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name_2 &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
			FileWriteLine($csv, '"'& StringLeft($FN_RTime_2,10) &'"'& $de &'"'& StringMid($FN_RTime_2,12,8) &'"'& $de &'"'& $UTCconfig &'"'& $de &'"'& "A" &'"'& $de &'"'& "MFT" &'"'& $de &'"'& $HDR_Flags &'"'& $de &'"'& "File Last Access" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "FN2" &'"'& $de &'"'& $FN_NamePath &'"'& $de &'"'& "" &'"'& $de &'"'& $FN_Name_2 &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& $RecordActive &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& @CRLF)
		EndIf
	ElseIf $DoBodyfile Then
;		If $SI_CTime <> "" Then
			FileWriteLine($csv, '"'& "" &'"'& $de &'"'& $FN_Name &'"'& $de &'"'& $HDR_MFTREcordNumber &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& "" &'"'& $de &'"'& $FileSizeBytes &'"'& $de &'"'& StringLeft($SI_ATime,19) &'"'& $de &'"'& StringLeft($SI_MTime,19) &'"'& $de &'"'& StringLeft($SI_CTime,19) &'"'& $de &'"'& StringLeft($SI_RTime,19) &'"'& @CRLF)
;		EndIf
	EndIf
EndFunc

Func _WriteCSVExtra()
	FileWriteLine($csvextra, $HDR_MFTREcordNumber & $de & $SI_CTime_Core & $de & $SI_CTime_Precision & $de & $SI_ATime_Core & $de & $SI_ATime_Precision & $de & $SI_MTime_Core & $de & $SI_MTime_Precision & $de & $SI_RTime_Core & $de & $SI_RTime_Precision & $de & _
	$FN_CTime_Core & $de & $FN_CTime_Precision & $de & $FN_ATime_Core & $de & $FN_ATime_Precision & $de & $FN_MTime_Core & $de & $FN_MTime_Precision & $de & $FN_RTime_Core & $de & $FN_RTime_Precision & $de & _
	$FN_CTime_2_Core & $de & $FN_CTime_2_Precision & $de & $FN_ATime_2_Core & $de & $FN_ATime_2_Precision & $de & $FN_MTime_2_Core & $de & $FN_MTime_2_Precision & $de & $FN_RTime_2_Core & $de & $FN_RTime_2_Precision & $de & _
	$FN_CTime_3_Core & $de & $FN_CTime_3_Precision & $de & $FN_ATime_3_Core & $de & $FN_ATime_3_Precision & $de & $FN_MTime_3_Core & $de & $FN_MTime_3_Precision & $de & $FN_RTime_3_Core & $de & $FN_RTime_3_Precision & @CRLF)
EndFunc

Func _WriteCSV()
	FileWriteLine($csv, $RecordOffset & $de & $Signature & $de & $IntegrityCheck & $de & $style & $de & $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $HDR_HardLinkCount & $de & $FN_ParentRefNo & $de & $FN_ParentSeqNo & $de & $FN_Name & $de & $FN_NamePath & $de & $HDR_Flags & $de & $RecordActive & $de & $FileSizeBytes & $de & $SI_FilePermission & $de & $FN_Flags & $de & $FN_NameType & $de & $ADS & $de & $SI_CTime & $de & $SI_ATime & $de & $SI_MTime & $de & $SI_RTime & $de & _
			$MSecTest & $de & $FN_CTime & $de & $FN_ATime & $de & $FN_MTime & $de & $FN_RTime & $de & $CTimeTest & $de & $FN_AllocSize & $de & $FN_RealSize & $de & $FN_EaSize & $de & $SI_USN & $de & $DT_Name & $de & $DT_Flags & $de & $DT_LengthOfAttribute & $de & $DT_IndexedFlag & $de & $DT_VCNs & $de & $DT_NonResidentFlag & $de & $DT_ComprUnitSize & $de & $HDR_LSN & $de & _
			$HDR_RecRealSize & $de & $HDR_RecAllocSize & $de & $HDR_BaseRecord & $de & $HDR_BaseRecSeqNo & $de & $HDR_NextAttribID & $de & $DT_AllocSize & $de & $DT_RealSize & $de & $DT_InitStreamSize & $de & $SI_HEADER_Flags & $de & $SI_MaxVersions & $de & $SI_VersionNumber & $de & $SI_ClassID & $de & $SI_OwnerID & $de & $SI_SecurityID & $de & $SI_Quota & $de & $FN_CTime_2 & $de & $FN_ATime_2 & $de & _
			$FN_MTime_2 & $de & $FN_RTime_2 & $de & $FN_AllocSize_2 & $de & $FN_RealSize_2 & $de & $FN_EaSize_2 & $de & $FN_Flags_2 & $de & $FN_NameLen_2 & $de & $FN_NameType_2 & $de & $FN_Name_2 & $de & $GUID_ObjectID & $de & $GUID_BirthVolumeID & $de & $GUID_BirthObjectID & $de & $GUID_BirthDomainID & $de & $VOLUME_NAME_NAME & $de & $VOL_INFO_NTFS_VERSION & $de & $VOL_INFO_FLAGS & $de & $FN_CTime_3 & $de & $FN_ATime_3 & $de & $FN_MTime_3 & $de & $FN_RTime_3 & $de & $FN_AllocSize_3 & $de & $FN_RealSize_3 & $de & $FN_EaSize_3 & $de & $FN_Flags_3 & $de & $FN_NameLen_3 & $de & $FN_NameType_3 & $de & $FN_Name_3 & $de & _
			$DT_Name_2 & $de & $DT_NonResidentFlag_2 & $de & $DT_Flags_2 & $de & $DT_LengthOfAttribute_2 & $de & $DT_IndexedFlag_2 & $de & $DT_StartVCN_2 & $de & $DT_LastVCN_2 & $de & _
			$DT_VCNs_2 & $de & $DT_ComprUnitSize_2 & $de & $DT_AllocSize_2 & $de & $DT_RealSize_2 & $de & $DT_InitStreamSize_2 & $de & $DT_Name_3 & $de & $DT_NonResidentFlag_3 & $de & $DT_Flags_3 & $de & $DT_LengthOfAttribute_3 & $de & $DT_IndexedFlag_3 & $de & $DT_StartVCN_3 & $de & $DT_LastVCN_3 & $de & $DT_VCNs_3 & $de & $DT_ComprUnitSize_3 & $de & $DT_AllocSize_3 & $de & _
			$DT_RealSize_3 & $de & $DT_InitStreamSize_3 & $de & $SI_ON & $de & $AL_ON & $de & $FN_ON & $de & $OI_ON & $de & $SD_ON & $de & $VN_ON & $de & $VI_ON & $de & $DT_ON & $de & $IR_ON & $de & $IA_ON & $de & $BITMAP_ON & $de & $RP_ON & $de & $EAI_ON & $de & $EA_ON & $de & $PS_ON & $de & $LUS_ON & @CRLF)
EndFunc

Func _WriteCSVExtraWithQuotes()
	FileWriteLine($csvextra, $HDR_MFTREcordNumber&'"'&$de&'"'&$SI_CTime_Core&'"'&$de&'"'&$SI_CTime_Precision&'"'&$de&'"'&$SI_ATime_Core&'"'&$de&'"'&$SI_ATime_Precision&'"'&$de&'"'&$SI_MTime_Core&'"'&$de&'"'&$SI_MTime_Precision&'"'&$de&'"'&$SI_RTime_Core&'"'&$de&'"'&$SI_RTime_Precision&'"'&$de&'"'& _
	$FN_CTime_Core&'"'&$de&'"'&$FN_CTime_Precision&'"'&$de&'"'&$FN_ATime_Core&'"'&$de&'"'&$FN_ATime_Precision&'"'&$de&'"'&$FN_MTime_Core&'"'&$de&'"'&$FN_MTime_Precision&'"'&$de&'"'&$FN_RTime_Core&'"'&$de&'"'&$FN_RTime_Precision&'"'&$de&'"'& _
	$FN_CTime_2_Core&'"'&$de&'"'&$FN_CTime_2_Precision&'"'&$de&'"'&$FN_ATime_2_Core&'"'&$de&'"'&$FN_ATime_2_Precision&'"'&$de&'"'&$FN_MTime_2_Core&'"'&$de&'"'&$FN_MTime_2_Precision&'"'&$de&'"'&$FN_RTime_2_Core&'"'&$de&'"'&$FN_RTime_2_Precision&'"'&$de&'"'& _
	$FN_CTime_3_Core&'"'&$de&'"'&$FN_CTime_3_Precision&'"'&$de&'"'&$FN_ATime_3_Core&'"'&$de&'"'&$FN_ATime_3_Precision&'"'&$de&'"'&$FN_MTime_3_Core&'"'&$de&'"'&$FN_MTime_3_Precision&'"'&$de&'"'&$FN_RTime_3_Core&'"'&$de&'"'&$FN_RTime_3_Precision&'"'&@CRLF)
EndFunc

Func _WriteCSVwithQuotes()
	FileWriteLine($csv, '"'&$RecordOffset&'"'&$de&'"'&$Signature&'"'&$de&'"'&$IntegrityCheck&'"'&$de&'"'&$style&'"'&$de&'"'&$HDR_MFTREcordNumber&'"'&$de&'"'&$HDR_SequenceNo&'"'&$de&'"'&$HDR_HardLinkCount&'"'&$de&'"'&$FN_ParentRefNo&'"'&$de&'"'&$FN_ParentSeqNo&'"'&$de&'"'&$FN_Name&'"'&$de&'"'&$FN_NamePath&'"'&$de&'"'&$HDR_Flags&'"'&$de&'"'&$RecordActive&'"'&$de&'"'&$FileSizeBytes&'"'&$de&'"'&$SI_FilePermission&'"'&$de&'"'&$FN_Flags&'"'&$de&'"'&$FN_NameType&'"'&$de&'"'&$ADS&'"'&$de&'"'&$SI_CTime&'"'&$de&'"' & _
		$SI_ATime&'"'&$de&'"'&$SI_MTime&'"'&$de&'"'&$SI_RTime&'"'&$de&'"'&$MSecTest&'"'&$de&'"'&$FN_CTime&'"'&$de&'"'&$FN_ATime&'"'&$de&'"'&$FN_MTime&'"'&$de&'"'&$FN_RTime&'"'&$de&'"'&$CTimeTest&'"'&$de&'"'&$FN_AllocSize&'"'&$de&'"'&$FN_RealSize&'"'&$de&'"'&$FN_EaSize&'"'&$de&'"'&$SI_USN&'"'&$de&'"'&$DT_Name&'"'&$de&'"'&$DT_Flags&'"'&$de&'"'&$DT_LengthOfAttribute&'"'&$de&'"'&$DT_IndexedFlag&'"'&$de&'"'&$DT_VCNs&'"'&$de&'"'&$DT_NonResidentFlag&'"'&$de&'"'&$DT_ComprUnitSize&'"'&$de&'"'&$HDR_LSN&'"'&$de&'"' & _
		$HDR_RecRealSize&'"'&$de&'"'&$HDR_RecAllocSize&'"'&$de&'"'&$HDR_BaseRecord&'"'&$de&'"'&$HDR_BaseRecSeqNo&'"'&$de&'"'&$HDR_NextAttribID&'"'&$de&'"'&$DT_AllocSize&'"'&$de&'"'&$DT_RealSize&'"'&$de&'"'&$DT_InitStreamSize&'"'&$de&'"'&$SI_HEADER_Flags&'"'&$de&'"'&$SI_MaxVersions&'"'&$de&'"'&$SI_VersionNumber&'"'&$de&'"'&$SI_ClassID&'"'&$de&'"'&$SI_OwnerID&'"'&$de&'"'&$SI_SecurityID&'"'&$de&'"'&$SI_Quota&'"'&$de&'"'&$FN_CTime_2&'"'&$de&'"'&$FN_ATime_2&'"'&$de&'"' & _
		$FN_MTime_2&'"'&$de&'"'&$FN_RTime_2&'"'&$de&'"'&$FN_AllocSize_2&'"'&$de&'"'&$FN_RealSize_2&'"'&$de&'"'&$FN_EaSize_2&'"'&$de&'"'&$FN_Flags_2&'"'&$de&'"'&$FN_NameLen_2&'"'&$de&'"'&$FN_NameType_2&'"'&$de&'"'&$FN_Name_2&'"'&$de&'"'&$GUID_ObjectID&'"'&$de&'"'&$GUID_BirthVolumeID&'"'&$de&'"'&$GUID_BirthObjectID&'"'&$de&'"'&$GUID_BirthDomainID&'"'&$de&'"'&$VOLUME_NAME_NAME&'"'&$de&'"'&$VOL_INFO_NTFS_VERSION&'"'&$de&'"'&$VOL_INFO_FLAGS&'"'&$de&'"'&$FN_CTime_3&'"'&$de&'"'&$FN_ATime_3&'"'&$de&'"'&$FN_MTime_3&'"'&$de&'"'&$FN_RTime_3&'"'&$de&'"'&$FN_AllocSize_3&'"'&$de&'"' & _
		$FN_RealSize_3&'"'&$de&'"'&$FN_EaSize_3&'"'&$de&'"'&$FN_Flags_3&'"'&$de&'"'&$FN_NameLen_3&'"'&$de&'"'&$FN_NameType_3&'"'&$de&'"'&$FN_Name_3&'"'&$de&'"'&$DT_Name_2&'"'&$de&'"'&$DT_NonResidentFlag_2&'"'&$de&'"'&$DT_Flags_2&'"'&$de&'"'&$DT_LengthOfAttribute_2&'"'&$de&'"'&$DT_IndexedFlag_2&'"'&$de&'"'&$DT_StartVCN_2&'"'&$de&'"'&$DT_LastVCN_2&'"'&$de&'"' & _
		$DT_VCNs_2&'"'&$de&'"'&$DT_ComprUnitSize_2&'"'&$de&'"'&$DT_AllocSize_2&'"'&$de&'"'&$DT_RealSize_2&'"'&$de&'"'&$DT_InitStreamSize_2&'"'&$de&'"'&$DT_Name_3&'"'&$de&'"'&$DT_NonResidentFlag_3&'"'&$de&'"'&$DT_Flags_3&'"'&$de&'"'&$DT_LengthOfAttribute_3&'"'&$de&'"'&$DT_IndexedFlag_3&'"'&$de&'"'&$DT_StartVCN_3&'"'&$de&'"'&$DT_LastVCN_3&'"'&$de&'"'&$DT_VCNs_3&'"'&$de&'"'&$DT_ComprUnitSize_3&'"'&$de&'"'&$DT_AllocSize_3&'"'&$de&'"' & _
		$DT_RealSize_3&'"'&$de&'"'&$DT_InitStreamSize_3&'"'&$de&'"'&$SI_ON&'"'&$de&'"'&$AL_ON&'"'&$de&'"'&$FN_ON&'"'&$de&'"'&$OI_ON&'"'&$de&'"'&$SD_ON&'"'&$de&'"'&$VN_ON&'"'&$de&'"'&$VI_ON&'"'&$de&'"'&$DT_ON&'"'&$de&'"'&$IR_ON&'"'&$de&'"'&$IA_ON&'"'&$de&'"'&$BITMAP_ON&'"'&$de&'"'&$RP_ON&'"'&$de&'"'&$EAI_ON&'"'&$de&'"'&$EA_ON&'"'&$de&'"'&$PS_ON&'"'&$de&'"'&$LUS_ON&'"'&@CRLF)
EndFunc


Func _WriteCSVHeader()
If $DoDefaultAll Then
	$csv_header = "RecordOffset"&$de&"Signature"&$de&"IntegrityCheck"&$de&"Style"&$de&"HEADER_MFTREcordNumber"&$de&"HEADER_SequenceNo"&$de&"Header_HardLinkCount"&$de&"FN_ParentReferenceNo"&$de&"FN_ParentSequenceNo"&$de&"FN_FileName"&$de&"FilePath"&$de&"HEADER_Flags"&$de&"RecordActive"&$de&"FileSizeBytes"&$de&"SI_FilePermission"&$de&"FN_Flags"&$de&"FN_NameType"&$de&"ADS"&$de&"SI_CTime"&$de&"SI_ATime"&$de&"SI_MTime"&$de&"SI_RTime"&$de&"MSecTest"&$de
	$csv_header &= "FN_CTime"&$de&"FN_ATime"&$de&"FN_MTime"&$de&"FN_RTime"&$de&"CTimeTest"&$de&"FN_AllocSize"&$de&"FN_RealSize"&$de&"FN_EaSize"&$de&"SI_USN"&$de&"DATA_Name"&$de&"DATA_Flags"&$de&"DATA_LengthOfAttribute"&$de&"DATA_IndexedFlag"&$de&"DATA_VCNs"&$de&"DATA_NonResidentFlag"&$de&"DATA_CompressionUnitSize"&$de&"HEADER_LSN"&$de&"HEADER_RecordRealSize"&$de
	$csv_header &= "HEADER_RecordAllocSize"&$de&"HEADER_BaseRecord"&$de&"HEADER_BaseRecSeqNo"&$de&"HEADER_NextAttribID"&$de&"DATA_AllocatedSize"&$de&"DATA_RealSize"&$de&"DATA_InitializedStreamSize"&$de&"SI_HEADER_Flags"&$de&"SI_MaxVersions"&$de&"SI_VersionNumber"&$de&"SI_ClassID"&$de&"SI_OwnerID"&$de&"SI_SecurityID"&$de&"SI_Quota"&$de&"FN_CTime_2"&$de&"FN_ATime_2"&$de&"FN_MTime_2"&$de
	$csv_header &= "FN_RTime_2"&$de&"FN_AllocSize_2"&$de&"FN_RealSize_2"&$de&"FN_EaSize_2"&$de&"FN_Flags_2"&$de&"FN_NameLength_2"&$de&"FN_NameType_2"&$de&"FN_FileName_2"&$de&"GUID_ObjectID"&$de&"GUID_BirthVolumeID"&$de&"GUID_BirthObjectID"&$de&"GUID_BirthDomainID"&$de&"VOLUME_NAME_NAME"&$de&"VOL_INFO_NTFS_VERSION"&$de&"VOL_INFO_FLAGS"&$de&"FN_CTime_3"&$de&"FN_ATime_3"&$de&"FN_MTime_3"&$de&"FN_RTime_3"&$de&"FN_AllocSize_3"&$de&"FN_RealSize_3"&$de&"FN_EaSize_3"&$de&"FN_Flags_3"&$de&"FN_NameLength_3"&$de&"FN_NameType_3"&$de&"FN_FileName_3"&$de
	$csv_header &= "DATA_Name_2"&$de&"DATA_NonResidentFlag_2"&$de&"DATA_Flags_2"&$de&"DATA_LengthOfAttribute_2"&$de&"DATA_IndexedFlag_2"&$de&"DATA_StartVCN_2"&$de&"DATA_LastVCN_2"&$de
	$csv_header &= "DATA_VCNs_2"&$de&"DATA_CompressionUnitSize_2"&$de&"DATA_AllocatedSize_2"&$de&"DATA_RealSize_2"&$de&"DATA_InitializedStreamSize_2"&$de&"DATA_Name_3"&$de&"DATA_NonResidentFlag_3"&$de&"DATA_Flags_3"&$de&"DATA_LengthOfAttribute_3"&$de&"DATA_IndexedFlag_3"&$de&"DATA_StartVCN_3"&$de&"DATA_LastVCN_3"&$de&"DATA_VCNs_3"&$de
	$csv_header &= "DATA_CompressionUnitSize_3"&$de&"DATA_AllocatedSize_3"&$de&"DATA_RealSize_3"&$de&"DATA_InitializedStreamSize_3"&$de&"STANDARD_INFORMATION_ON"&$de&"ATTRIBUTE_LIST_ON"&$de&"FILE_NAME_ON"&$de&"OBJECT_ID_ON"&$de&"SECURITY_DESCRIPTOR_ON"&$de&"VOLUME_NAME_ON"&$de&"VOLUME_INFORMATION_ON"&$de&"DATA_ON"&$de&"INDEX_ROOT_ON"&$de&"INDEX_ALLOCATION_ON"&$de&"BITMAP_ON"&$de&"REPARSE_POINT_ON"&$de&"EA_INFORMATION_ON"&$de&"EA_ON"&$de&"PROPERTY_SET_ON"&$de&"LOGGED_UTILITY_STREAM_ON"
ElseIf $dol2t Then
	$csv_header = "Date"&$de&"Time"&$de&"Timezone"&$de&"MACB"&$de&"Source"&$de&"SourceType"&$de&"Type"&$de&"User"&$de&"Host"&$de&"Short"&$de&"Desc"&$de&"Version"&$de&"Filename"&$de&"Inode"&$de&"Notes"&$de&"Format"&$de&"Extra"
ElseIf $DoBodyfile Then
	$csv_header = "MD5"&$de&"name"&$de&"inode"&$de&"mode_as_string"&$de&"UID"&$de&"GID"&$de&"size"&$de&"atime"&$de&"mtime"&$de&"ctime"&$de&"rtime"
EndIf
FileWriteLine($csv, $csv_header & @CRLF)
EndFunc

Func _WriteCSVExtraHeader()
	Local $csv_extra_header
	$csvextra = @ScriptDir&"\MftExtra_"&$TimestampStart&".csv"
	$csv_extra_header = "HEADER_MFTREcordNumber"&$de&"SI_CTime_Core"&$de&"SI_CTime_Precision"&$de&"SI_ATime_Core"&$de&"SI_ATime_Precision"&$de&"SI_MTime_Core"&$de&"SI_MTime_Precision"&$de&"SI_RTime_Core"&$de&"SI_RTime_Precision"&$de
	$csv_extra_header &= "FN_CTime_Core"&$de&"FN_CTime_Precision"&$de&"FN_ATime_Core"&$de&"FN_ATime_Precision"&$de&"FN_MTime_Core"&$de&"FN_MTime_Precision"&$de&"FN_RTime_Core"&$de&"FN_RTime_Precision"&$de
	$csv_extra_header &= "FN_CTime_2_Core"&$de&"FN_CTime_2_Precision"&$de&"FN_ATime_2_Core"&$de&"FN_ATime_2_Precision"&$de&"FN_MTime_2_Core"&$de&"FN_MTime_2_Precision"&$de&"FN_RTime_2_Core"&$de&"FN_RTime_2_Precision"&$de
	$csv_extra_header &= "FN_CTime_3_Core"&$de&"FN_CTime_3_Precision"&$de&"FN_ATime_3_Core"&$de&"FN_ATime_3_Precision"&$de&"FN_MTime_3_Core"&$de&"FN_MTime_3_Precision"&$de&"FN_RTime_3_Core"&$de&"FN_RTime_3_Precision"
	FileWriteLine($csvextra, $csv_extra_header & @CRLF)
EndFunc

Func _InjectTimeZoneInfo()
$Regions = "UTC: -12.00|" & _
	"UTC: -11.00|" & _
	"UTC: -10.00|" & _
	"UTC: -9.30|" & _
	"UTC: -9.00|" & _
	"UTC: -8.00|" & _
	"UTC: -7.00|" & _
	"UTC: -6.00|" & _
	"UTC: -5.00|" & _
	"UTC: -4.30|" & _
	"UTC: -4.00|" & _
	"UTC: -3.30|" & _
	"UTC: -3.00|" & _
	"UTC: -2.00|" & _
	"UTC: -1.00|" & _
	"UTC: 0.00|" & _
	"UTC: 1.00|" & _
	"UTC: 2.00|" & _
	"UTC: 3.00|" & _
	"UTC: 3.30|" & _
	"UTC: 4.00|" & _
	"UTC: 4.30|" & _
	"UTC: 5.00|" & _
	"UTC: 5.30|" & _
	"UTC: 5.45|" & _
	"UTC: 6.00|" & _
	"UTC: 6.30|" & _
	"UTC: 7.00|" & _
	"UTC: 8.00|" & _
	"UTC: 8.45|" & _
	"UTC: 9.00|" & _
	"UTC: 9.30|" & _
	"UTC: 10.00|" & _
	"UTC: 10.30|" & _
	"UTC: 11.00|" & _
	"UTC: 11.30|" & _
	"UTC: 12.00|" & _
	"UTC: 12.45|" & _
	"UTC: 13.00|" & _
	"UTC: 14.00|"
GUICtrlSetData($Combo2,$Regions,"UTC: 0.00")
EndFunc

Func _GetUTCRegion($UTCRegion)
	If $UTCRegion = "" Then Return SetError(1,0,0)

	If StringInStr($UTCRegion,"UTC:") Then
		$part1 = StringMid($UTCRegion,StringInStr($UTCRegion," ")+1)
	Else
		$part1 = $UTCRegion
	EndIf
	Global $UTCconfig = $part1
	If StringRight($part1,2) = "15" Then $part1 = StringReplace($part1,".15",".25")
	If StringRight($part1,2) = "30" Then $part1 = StringReplace($part1,".30",".50")
	If StringRight($part1,2) = "45" Then $part1 = StringReplace($part1,".45",".75")
	$DeltaTest = $part1*36000000000
	Return $DeltaTest
EndFunc

; start: by Ascend4nt -----------------------------
Func _WinTime_GetUTCToLocalFileTimeDelta()
	Local $iUTCFileTime=864000000000		; exactly 24 hours from the origin (although 12 hours would be more appropriate (max variance = 12))
	$iLocalFileTime=_WinTime_UTCFileTimeToLocalFileTime($iUTCFileTime)
	If @error Then Return SetError(@error,@extended,-1)
	Return $iLocalFileTime-$iUTCFileTime	; /36000000000 = # hours delta (effectively giving the offset in hours from UTC/GMT)
EndFunc

Func _WinTime_UTCFileTimeToLocalFileTime($iUTCFileTime)
	If $iUTCFileTime<0 Then Return SetError(1,0,-1)
	Local $aRet=DllCall($_COMMON_KERNEL32DLL,"bool","FileTimeToLocalFileTime","uint64*",$iUTCFileTime,"uint64*",0)
	If @error Then Return SetError(2,@error,-1)
	If Not $aRet[0] Then Return SetError(3,0,-1)
	Return $aRet[2]
EndFunc

Func _WinTime_UTCFileTimeFormat($iUTCFileTime,$iFormat=4,$iPrecision=0,$bAMPMConversion=False)
;~ 	If $iUTCFileTime<0 Then Return SetError(1,0,"")	; checked in below call

	; First convert file time (UTC-based file time) to 'local file time'
	Local $iLocalFileTime=_WinTime_UTCFileTimeToLocalFileTime($iUTCFileTime)
	If @error Then Return SetError(@error,@extended,"")
	; Rare occassion: a filetime near the origin (January 1, 1601!!) is used,
	;	causing a negative result (for some timezones). Return as invalid param.
	If $iLocalFileTime<0 Then Return SetError(1,0,"")

	; Then convert file time to a system time array & format & return it
	Local $vReturn=_WinTime_LocalFileTimeFormat($iLocalFileTime,$iFormat,$iPrecision,$bAMPMConversion)
	Return SetError(@error,@extended,$vReturn)
EndFunc

Func _WinTime_LocalFileTimeFormat($iLocalFileTime,$iFormat=4,$iPrecision=0,$bAMPMConversion=False)
;~ 	If $iLocalFileTime<0 Then Return SetError(1,0,"")	; checked in below call

	; Convert file time to a system time array & return result
	Local $aSysTime=_WinTime_LocalFileTimeToSystemTime($iLocalFileTime)
	If @error Then Return SetError(@error,@extended,"")

	; Return only the SystemTime array?
	If $iFormat=0 Then Return $aSysTime

	Local $vReturn=_WinTime_FormatTime($aSysTime[0],$aSysTime[1],$aSysTime[2],$aSysTime[3], _
		$aSysTime[4],$aSysTime[5],$aSysTime[6],$aSysTime[7],$iFormat,$iPrecision,$bAMPMConversion)
	Return SetError(@error,@extended,$vReturn)
EndFunc

Func _WinTime_LocalFileTimeToSystemTime($iLocalFileTime)
	Local $aRet,$stSysTime,$aSysTime[8]=[-1,-1,-1,-1,-1,-1,-1,-1]

	; Negative values unacceptable
	If $iLocalFileTime<0 Then Return SetError(1,0,$aSysTime)

	; SYSTEMTIME structure [Year,Month,DayOfWeek,Day,Hour,Min,Sec,Milliseconds]
	$stSysTime=DllStructCreate("ushort[8]")

	$aRet=DllCall($_COMMON_KERNEL32DLL,"bool","FileTimeToSystemTime","uint64*",$iLocalFileTime,"ptr",DllStructGetPtr($stSysTime))
	If @error Then Return SetError(2,@error,$aSysTime)
	If Not $aRet[0] Then Return SetError(3,0,$aSysTime)
	Dim $aSysTime[8]=[DllStructGetData($stSysTime,1,1),DllStructGetData($stSysTime,1,2),DllStructGetData($stSysTime,1,4),DllStructGetData($stSysTime,1,5), _
		DllStructGetData($stSysTime,1,6),DllStructGetData($stSysTime,1,7),DllStructGetData($stSysTime,1,8),DllStructGetData($stSysTime,1,3)]
	Return $aSysTime
EndFunc

Func _WinTime_FormatTime($iYear,$iMonth,$iDay,$iHour,$iMin,$iSec,$iMilSec,$iDayOfWeek,$iFormat=4,$iPrecision=0,$bAMPMConversion=False)
	Local Static $_WT_aMonths[12]=["January","February","March","April","May","June","July","August","September","October","November","December"]
	Local Static $_WT_aDays[7]=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

	If Not $iFormat Or $iMonth<1 Or $iMonth>12 Or $iDayOfWeek>6 Then Return SetError(1,0,"")

	; Pad MM,DD,HH,MM,SS,MSMSMSMS as necessary
	Local $sMM=StringRight(0&$iMonth,2),$sDD=StringRight(0&$iDay,2),$sMin=StringRight(0&$iMin,2)
	; $sYY = $iYear	; (no padding)
	;	[technically Year can be 1-x chars - but this is generally used for 4-digit years. And SystemTime only goes up to 30827/30828]
	Local $sHH,$sSS,$sMS,$sAMPM

	; 'Extra precision 1': +SS (Seconds)
	If $iPrecision Then
		$sSS=StringRight(0&$iSec,2)
		; 'Extra precision 2': +MSMSMSMS (Milliseconds)
		If $iPrecision>1 Then
;			$sMS=StringRight('000'&$iMilSec,4)
			$sMS=StringRight('000'&$iMilSec,3);Fixed an erronous 0 in front of the milliseconds
		Else
			$sMS=""
		EndIf
	Else
		$sSS=""
		$sMS=""
	EndIf
	If $bAMPMConversion Then
		If $iHour>11 Then
			$sAMPM=" PM"
			; 12 PM will cause 12-12 to equal 0, so avoid the calculation:
			If $iHour=12 Then
				$sHH="12"
			Else
				$sHH=StringRight(0&($iHour-12),2)
			EndIf
		Else
			$sAMPM=" AM"
			If $iHour Then
				$sHH=StringRight(0&$iHour,2)
			Else
			; 00 military = 12 AM
				$sHH="12"
			EndIf
		EndIf
	Else
		$sAMPM=""
		$sHH=StringRight(0 & $iHour,2)
	EndIf

	Local $sDateTimeStr,$aReturnArray[3]

	; Return an array? [formatted string + "Month" + "DayOfWeek"]
	If BitAND($iFormat,0x10) Then
		$aReturnArray[1]=$_WT_aMonths[$iMonth-1]
		If $iDayOfWeek>=0 Then
			$aReturnArray[2]=$_WT_aDays[$iDayOfWeek]
		Else
			$aReturnArray[2]=""
		EndIf
		; Strip the 'array' bit off (array[1] will now indicate if an array is to be returned)
		$iFormat=BitAND($iFormat,0xF)
	Else
		; Signal to below that the array isn't to be returned
		$aReturnArray[1]=""
	EndIf

	; Prefix with "DayOfWeek "?
	If BitAND($iFormat,8) Then
		If $iDayOfWeek<0 Then Return SetError(1,0,"")	; invalid
		$sDateTimeStr=$_WT_aDays[$iDayOfWeek]&', '
		; Strip the 'DayOfWeek' bit off
		$iFormat=BitAND($iFormat,0x7)
	Else
		$sDateTimeStr=""
	EndIf

	If $iFormat<2 Then
		; Basic String format: YYYYMMDDHHMM[SS[MSMSMSMS[ AM/PM]]]
		$sDateTimeStr&=$iYear&$sMM&$sDD&$sHH&$sMin&$sSS&$sMS&$sAMPM
	Else
		; one of 4 formats which ends with " HH:MM[:SS[:MSMSMSMS[ AM/PM]]]"
		Switch $iFormat
			; /, : Format - MM/DD/YYYY
			Case 2
				$sDateTimeStr&=$sMM&'/'&$sDD&'/'
			; /, : alt. Format - DD/MM/YYYY
			Case 3
				$sDateTimeStr&=$sDD&'/'&$sMM&'/'
			; "Month DD, YYYY" format
			Case 4
				$sDateTimeStr&=$_WT_aMonths[$iMonth-1]&' '&$sDD&', '
			; "DD Month YYYY" format
			Case 5
				$sDateTimeStr&=$sDD&' '&$_WT_aMonths[$iMonth-1]&' '
			Case 6
				$sDateTimeStr&=$iYear&'-'&$sMM&'-'&$sDD
				$iYear=''
			Case Else
				Return SetError(1,0,"")
		EndSwitch
		$sDateTimeStr&=$iYear&' '&$sHH&':'&$sMin
		If $iPrecision Then
			$sDateTimeStr&=':'&$sSS
;			If $iPrecision>1 Then $sDateTimeStr&=':'&$sMS
			If $iPrecision>1 Then $sDateTimeStr&=$PrecisionSeparator&$sMS
		EndIf
		$sDateTimeStr&=$sAMPM
	EndIf
	If $aReturnArray[1]<>"" Then
		$aReturnArray[0]=$sDateTimeStr
		Return $aReturnArray
	EndIf
	Return $sDateTimeStr
EndFunc
; end: by Ascend4nt ----------------------------

Func _TranslateSeparator()
	; Or do it the other way around to allow setting other trickier separators, like specifying it in hex
	GUICtrlSetData($SeparatorInput,StringLeft(GUICtrlRead($SeparatorInput),1))
	GUICtrlSetData($SeparatorInput2,"0x"&Hex(Asc(GUICtrlRead($SeparatorInput)),2))
EndFunc

Func _GenDummyDataQ()
	Global $DataQ[2]
	Local $PartA, $PartB, $PartD, $PartF, $PartH, $PartI, $PartJ, $PartK
	$PartA = "8000000048000000010040000000010000000000000000003F000000000000004000000000000000"
	$partB = _SwapEndian(Hex($MftFileSize,16)) ; Allocated size
	$partD = _SwapEndian(Hex($MftFileSize,16)) ; Real size
	$partF = _SwapEndian(Hex($MftFileSize,16)) ; Initialized size
	$partH = "14"
	$partI = Hex(Int(((512+$MftFileSize-Mod($MftFileSize,512))/512/8)),8)
	$partJ = "01"
	$partK = "0000"
	$DataQ[1] = $PartA & $PartB & $PartD & $PartF & $PartH & $PartI & $PartJ & $PartK
	$ClustersPerFileRecordSegment = Ceiling($MFT_Record_Size/$BytesPerCluster)
	$BytesPerSector = 512
EndFunc

Func _ExtractSingleFile($MFTRecord, $FileRef)
	Global $DataQ[1]				;clear array
	$MFTRecord = _DecodeMFTRecord($MFTRecord, $FileRef)
	If $MFTRecord = "" Then Return	;error so finish
	If UBound($DataQ) = 1 Then
		_DebugOut($FileRef & " No $DATA attribute for the file: " & $FN_FileName, $MFTRecord)
		Return
	EndIf
	For $i = 1 To UBound($DataQ) - 1
		_DecodeDataQEntry($DataQ[$i])
		If $ADS_Name = "" Then
			_DebugOut($FileRef & " No $NAME attribute for the file",$MFTRecord)
			Return
		EndIf
		If $NonResidentFlag = '00' Then
			_ExtractResidentFile($ADS_Name, $DT_LengthOfAttribute, $MFTRecord)
		Else
;			Skipping Non-resident
		EndIf
	Next
EndFunc

Func _ExtractResidentFile($Name, $Size, $record)
	Local $nBytes
	$xBuffer = DllStructCreate("byte[" & $Size & "]")
    DllStructSetData($xBuffer, 1, '0x' & $DataRun)
    $zflag = 0
	Do
        DirCreate(StringMid($Name, 1, StringInStr($Name,"\",0,-1)))
;		$hFile = _WinAPI_CreateFile("\\.\" & $ExtractionPath & "\" & $Name,3,6,7)
		$hFile = _WinAPI_CreateFile("\\.\" & $ExtractionPath & "\[0x" & Hex($CurrentProgress*$MFT_Record_Size,8) & "]" & $Name,3,6,7)
;		$hFile = _WinAPI_CreateFile("\\.\" & $ExtractionPath & "\" & $Name & "[0x" & Hex($CurrentProgress*1024,8) & "]",3,6,7)
        If $hFile Then
            _WinAPI_SetFilePointer($hFile, 0,$FILE_BEGIN)
            _WinAPI_WriteFile($hFile, DllStructGetPtr($xBuffer), $Size, $nBytes)
            _WinAPI_CloseHandle($hFile)
            If StringInStr($Name, $subst) Then $ret = _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
            Return
        Else
            If $zflag = 0 Then		;first pass
			   $mid = Int(StringLen($Name)/2)
			   $zPath = StringMid($Name, 1, StringInStr($Name, "\", 0, -1, $mid)-1)
			ElseIf $zflag = 1 Then		;second pass
			   $ret = _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
			   $Name = StringReplace($Name,$subst, $zPath)	;restore full name
			   $zPath = StringMid($Name, 1, StringInStr($Name, "\", 0, 1, $mid)-1)
			Else		;fail
			   _DebugOut("Error in creating resident file " & StringReplace($Name,$subst,$zPath), $record)
			   $ret = _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
			   Return
			EndIf
			$ret = _WinAPI_DefineDosDevice($subst, 0, $zPath)     ;open spare
			$Name = StringReplace($Name,$zPath, $subst)
			$zflag += 1
		 EndIf
    Until $hFile
EndFunc

Func _SetExtractionPath()
	$ExtractionPath = FileSelectFolder("Select path for extracted resident data.", "",7,@scriptdir)
	If @error Then Return
EndFunc

Func _GetPhysicalDrives($InputDevice)
	Local $PhysicalDriveString, $hFile0
	If StringLeft($InputDevice,10) = "GLOBALROOT" Then ; Shadow copies starts at 1 whereas physical drive starts at 0
		$i=1
	Else
		$i=0
	EndIf
	GUICtrlSetData($Combo,"","")
	$Entries = ''
	GUICtrlSetData($ComboPhysicalDrives,"","")
	$sDrivePath = '\\.\'&$InputDevice
;	ConsoleWrite("$sDrivePath: " & $sDrivePath & @CRLF)
	Do
		$hFile0 = _WinAPI_CreateFile($sDrivePath & $i,2,2,2)
		If $hFile0 <> 0 Then
			ConsoleWrite("Found: " & $sDrivePath & $i & @CRLF)
			_WinAPI_CloseHandle($hFile0)
			$PhysicalDriveString &= $sDrivePath&$i&"|"
		EndIf
		$i+=1
	Until $hFile0=0
	GUICtrlSetData($ComboPhysicalDrives, $PhysicalDriveString, StringMid($PhysicalDriveString, 1, StringInStr($PhysicalDriveString, "|") -1))
EndFunc

Func _TestPhysicalDrive()
	$TargetImageFile = GUICtrlRead($ComboPhysicalDrives)
	If @error then Return
	_DisplayInfo("Target is " & $TargetImageFile & @CRLF)
	GUICtrlSetData($Combo,"","")
	$Entries = ''
	_CheckMBR()
	GUICtrlSetData($Combo,$Entries,StringMid($Entries, 1, StringInStr($Entries, "|") -1))
	If $Entries = "" Then _DisplayInfo("Sorry, no NTFS volume found" & @CRLF)
	If StringInStr($TargetImageFile,"GLOBALROOT") Then
		$IsShadowCopy=True
		$IsPhysicalDrive=False
		$IsImage=False
	ElseIf StringInStr($TargetImageFile,"PhysicalDrive") Then
		$IsShadowCopy=False
		$IsPhysicalDrive=True
		$IsImage=False
	EndIf
EndFunc

Func _InjectTimestampFormat()
Local $Formats = "1|" & _
	"2|" & _
	"3|" & _
	"4|" & _
	"5|" & _
	"6|"
	GUICtrlSetData($ComboTimestampFormat,$Formats,"6")
EndFunc

Func _InjectTimestampPrecision()
Local $Precision = "None|" & _
	"MilliSec|" & _
	"NanoSec|"
	GUICtrlSetData($ComboTimestampPrecision,$Precision,"NanoSec")
EndFunc

Func _TranslateTimestamp()
	Local $lPrecision,$lTimestamp,$lTimestampTmp
	$DateTimeFormat = StringLeft(GUICtrlRead($ComboTimestampFormat),1)
	$lPrecision = GUICtrlRead($ComboTimestampPrecision)
	Select
		Case $lPrecision = "None"
			$TimestampPrecision = 1
		Case $lPrecision = "MilliSec"
			$TimestampPrecision = 2
		Case $lPrecision = "NanoSec"
			$TimestampPrecision = 3
	EndSelect
	$lTimestampTmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $ExampleTimestampVal)
	$lTimestamp = _WinTime_UTCFileTimeFormat(Dec($ExampleTimestampVal,2), $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$lTimestamp = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$lTimestamp = $lTimestamp & $PrecisionSeparator2 & _FillZero(StringRight($lTimestampTmp, 4))
	EndIf
	GUICtrlSetData($InputExampleTimestamp,$lTimestamp)
EndFunc

Func _SelectCsv()
	$csvfile = @ScriptDir&"\MftDump_"&$TimestampStart&".csv"
	$csv = FileOpen($csvfile, $EncodingWhenOpen)
	If @error Then Return
	_DisplayInfo("Output CSV file: " & $csvfile & @CRLF)
	_DebugOut("Output CSV file: " & $csvfile)
EndFunc

Func _GetRunsFromAttributeListMFT0()
	For $i = 1 To UBound($DataQ) - 1
		_DecodeDataQEntry($DataQ[$i])
		If $NonResidentFlag = '00' Then
;			ConsoleWrite("Resident" & @CRLF)
		Else
			Global $RUN_VCN[1], $RUN_Clusters[1]
			$TotalClusters = $DT_Clusters
			$RealSize = $DT_RealSize		;preserve file sizes
			If Not $InitState Then $DT_InitSize = $DT_RealSize
			$InitSize = $DT_InitSize
			_ExtractDataRuns()
			If $TotalClusters * $BytesPerCluster >= $RealSize Then
;				_ExtractFile($MFTRecord)
			Else 		 ;code to handle attribute list
				$Flag = $IsCompressed		;preserve compression state
				For $j = $i + 1 To UBound($DataQ) -1
					_DecodeDataQEntry($DataQ[$j])
					$TotalClusters += $DT_Clusters
					_ExtractDataRuns()
					If $TotalClusters * $BytesPerCluster >= $RealSize Then
						$DT_RealSize = $RealSize		;restore file sizes
						$DT_InitSize = $InitSize
						$IsCompressed = $Flag		;recover compression state
						ExitLoop
					EndIf
				Next
				$i = $j
			EndIf
		EndIf
	Next
EndFunc

Func _GetInputParams()
	Local $TimeZone, $OutputFormat
	For $i = 1 To $cmdline[0]
		;ConsoleWrite("Param " & $i & ": " & $cmdline[$i] & @CRLF)
		If StringLeft($cmdline[$i],8) = "/Volume:" Then $TargetDrive = StringMid($cmdline[$i],9)
		If StringLeft($cmdline[$i],9) = "/MftFile:" Then $TargetMftFile = StringMid($cmdline[$i],10)
		If StringLeft($cmdline[$i],13) = "/ExtractPath:" Then $ExtractionPath = StringMid($cmdline[$i],14)
		If StringLeft($cmdline[$i],17) = "/ExtractResident:" Then $ExtractResident = StringMid($cmdline[$i],19)
		If StringLeft($cmdline[$i],10) = "/TimeZone:" Then $TimeZone = StringMid($cmdline[$i],11)
		If StringLeft($cmdline[$i],14) = "/OutputFormat:" Then $OutputFormat = StringMid($cmdline[$i],15)
		If StringLeft($cmdline[$i],12) = "/SkipFixups:" Then $checkFixups = StringMid($cmdline[$i],13)
		If StringLeft($cmdline[$i],11) = "/BrokenMft:" Then $checkBrokenMFT = StringMid($cmdline[$i],12)
		If StringLeft($cmdline[$i],11) = "/Separator:" Then $SeparatorInput = StringMid($cmdline[$i],12)
		If StringLeft($cmdline[$i],15) = "/QuotationMark:" Then $checkquotes = StringMid($cmdline[$i],16)
		If StringLeft($cmdline[$i],9) = "/Unicode:" Then $CheckUnicode = StringMid($cmdline[$i],10)
		If StringLeft($cmdline[$i],10) = "/TSFormat:" Then $DateTimeFormat = StringMid($cmdline[$i],11)
		If StringLeft($cmdline[$i],13) = "/TSPrecision:" Then $TimestampPrecision = StringMid($cmdline[$i],14)
		If StringLeft($cmdline[$i],22) = "/TSPrecisionSeparator:" Then $PrecisionSeparator = StringMid($cmdline[$i],23)
		If StringLeft($cmdline[$i],23) = "/TSPrecisionSeparator2:" Then $PrecisionSeparator2 = StringMid($cmdline[$i],24)
		If StringLeft($cmdline[$i],12) = "/TSErrorVal:" Then $TimestampErrorVal = StringMid($cmdline[$i],13)
		If StringLeft($cmdline[$i],10) = "/SplitCsv:" Then $CheckCsvSplit = StringMid($cmdline[$i],11)
		If StringLeft($cmdline[$i],12) = "/RecordSize:" Then $MFT_Record_Size = StringMid($cmdline[$i],13)
	Next

	If $MFT_Record_Size <> 4096 Then $MFT_Record_Size = 1024

	If StringLen($TimeZone) > 0 Then
		Select
			Case $TimeZone = "-12.00"
			Case $TimeZone = "-11.00"
			Case $TimeZone = "-10.00"
			Case $TimeZone = "-9.30"
			Case $TimeZone = "-9.00"
			Case $TimeZone = "-8.00"
			Case $TimeZone = "-7.00"
			Case $TimeZone = "-6.00"
			Case $TimeZone = "-5.00"
			Case $TimeZone = "-4.30"
			Case $TimeZone = "-4.00"
			Case $TimeZone = "-3.30"
			Case $TimeZone = "-3.00"
			Case $TimeZone = "-2.00"
			Case $TimeZone = "-1.00"
			Case $TimeZone = "0.00"
			Case $TimeZone = "1.00"
			Case $TimeZone = "2.00"
			Case $TimeZone = "3.00"
			Case $TimeZone = "3.30"
			Case $TimeZone = "4.00"
			Case $TimeZone = "4.30"
			Case $TimeZone = "5.00"
			Case $TimeZone = "5.30"
			Case $TimeZone = "5.45"
			Case $TimeZone = "6.00"
			Case $TimeZone = "6.30"
			Case $TimeZone = "7.00"
			Case $TimeZone = "8.00"
			Case $TimeZone = "8.45"
			Case $TimeZone = "9.00"
			Case $TimeZone = "9.30"
			Case $TimeZone = "10.00"
			Case $TimeZone = "10.30"
			Case $TimeZone = "11.00"
			Case $TimeZone = "11.30"
			Case $TimeZone = "12.00"
			Case $TimeZone = "12.45"
			Case $TimeZone = "13.00"
			Case $TimeZone = "14.00"
			Case Else
				$TimeZone = "0.00"
		EndSelect
	Else
		$TimeZone = "0.00"
	EndIf

	$tDelta = _GetUTCRegion($TimeZone)-$tDelta
	If @error Then
		_DisplayInfo("Error: Timezone configuration failed." & @CRLF)
	Else
		_DisplayInfo("Timestamps presented in UTC: " & $UTCconfig & @CRLF)
	EndIf
	$tDelta = $tDelta*-1

	$IsPhysicalDrive = 0
	$IsImage = 0
	$IsShadowCopy = 0
	$IsMftFile = 0

	If StringLen($TargetMftFile) > 0 Then
		If Not FileExists($TargetMftFile) Then
			ConsoleWrite("Error input $MFT file does not exist." & @CRLF)
			Exit
		EndIf
		$IsMftFile = 1
		$hDisk = _WinAPI_CreateFile("\\.\" & $TargetMftFile,2,2,7)
		If $hDisk = 0 Then
			_DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
			Exit
		EndIf
		$MftFileSize = _WinAPI_GetFileSizeEx($hDisk)
	EndIf

	If StringLen($TargetDrive) > 0 Then
		If $IsMftFile Then
			ConsoleWrite("Error multiple input files" & @CRLF)
			Exit
		EndIf
		If StringLen($TargetDrive) <> 2 Then
			ConsoleWrite("Error input volume in bad format." & @CRLF)
			Exit
		EndIf
		$hDisk = _WinAPI_CreateFile("\\.\" & $TargetDrive,2,2,7)
		If $hDisk = 0 Then
			_DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
			Exit
		EndIf
	EndIf

	If Not $hDisk Then
		_DebugOut("Error obtaining a handle on input file or volume.")
		Exit
	EndIf

	If StringLen($OutputFormat) > 0 Then
		If $OutputFormat = "l2t" Then $checkl2t = 1
		If $OutputFormat = "bodyfile" Then $checkbodyfile = 1
		If $OutputFormat = "all" Then $checkdefaultall = 1
		If $checkl2t + $checkbodyfile = 0 Then $checkdefaultall = 1
	Else
		$checkdefaultall = 1
	EndIf

	If $ExtractResident Then
		If Not FileExists($ExtractionPath) Then
			$ExtractionPath = @ScriptDir
		EndIf
	EndIf

	If StringLen($PrecisionSeparator) <> 1 Then $PrecisionSeparator = "."
	If StringLen($SeparatorInput) <> 1 Then $SeparatorInput = "|"

	If StringLen($TimestampPrecision) > 0 Then
		Select
			Case $TimestampPrecision = "None"
				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
				$TimestampPrecision = 1
			Case $TimestampPrecision = "MilliSec"
				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
				$TimestampPrecision = 2
			Case $TimestampPrecision = "NanoSec"
				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
				$TimestampPrecision = 3
		EndSelect
	Else
		$TimestampPrecision = 1
	EndIf

	If StringLen($DateTimeFormat) > 0 Then
		If $DateTimeFormat <> 1 And $DateTimeFormat <> 2 And $DateTimeFormat <> 3 And $DateTimeFormat <> 4 And $DateTimeFormat <> 5 And $DateTimeFormat <> 6 Then
			$DateTimeFormat = 6
		EndIf
	Else
		$DateTimeFormat = 6
	EndIf
EndFunc