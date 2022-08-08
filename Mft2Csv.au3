;#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_Outfile=Mft2Csv.exe
#AutoIt3Wrapper_Outfile_x64=Mft2Csv64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Decode $MFT and write to CSV
#AutoIt3Wrapper_Res_Description=Decode $MFT and write to CSV
#AutoIt3Wrapper_Res_Fileversion=2.0.0.44
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_AU3Check_Parameters=-w 3 -w 5
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/sf /sv /rm /pe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Include <WinAPIEx.au3>
#Include <File.au3>
#include <String.au3>
#include <Date.au3>
#include <array.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <FontConstants.au3>

Global $Progversion = "Mft2Csv 2.0.0.44"

; parts by Ddan, trancexxx, Ascend4nt & others

Global $DummyPrependBytes = "00000000000000000000000000000000000000000000000000000000000000000000000000000000"
; output structure & csv
Global $OutputPath = @ScriptDir
Global $csv, $csvfile, $I30EntriesCsv, $I30EntriesCsvFile
Global $RBICsv,$RBICsvFile,$EntriesObjectIdCsvFile, $EntriesObjectIdCsv, $ReparsePointCsvFile, $ReparsePointCsv, $ReparsePointAppExecLinkCsvFile, $ReparsePointAppExecLinkCsv
Global $EaCsv, $EaCsvFile, $LoggedUtilityStreamTxfDataCsv, $LoggedUtilityStreamTxfDataCsvFile, $LoggedUtilityStreamCsv, $LoggedUtilityStreamCsvFile, $NewI30EntriesCsv, $NewI30EntriesCsvFile, $AdditionalDataCsvFile, $AdditionalDataCsv
Global $DoSplitCsv=False, $csvextra

Global $_COMMON_KERNEL32DLL=DllOpen("kernel32.dll"), $separator="|", $PrecisionSeparator=".", $PrecisionSeparator2="", $dol2t=False, $DoDefaultAll=False, $DoBodyfile=False, $SkipFixups=False, $MftIsBroken=False, $ExtractResidentData=False, $ExtractResidentSlack=False, $style
Global $RecordOffset, $RecordOffsetDec, $Signature, $ADS, $FN_NamePath, $UTCconfig, $de="|", $MftFileSize, $FN_FileName, $LogicalClusterNumberforthefileMFT, $ClustersPerFileRecordSegment, $MftAttrListString, $BytesPerSector, $SplitMftRecArr[1]
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
Global $GUID_ObjectID, $GUID_BirthVolumeID, $GUID_BirthObjectID, $GUID_DomainID, $VOLUME_NAME_NAME, $VOL_INFO_NTFS_VERSION, $VOL_INFO_FLAGS, $INV_FNAME, $INV_FNAME_2, $INV_FNAME_3, $DT_Number
Global $FileSizeBytes, $IntegrityCheck, $ComboPhysicalDrives, $IsPhysicalDrive=False,$GlobalRefCounter=0,$IsShadowCopy=False,$EncodingWhenOpen=2,$DoBruteForceSlack=0
Global $SI_CTime_tmp, $FN_CTime_tmp
Global $TimestampErrorVal = "0000-00-00 00:00:00"

Global $TimeDiff = 5748192000000000 ; for use with guid only

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

Global $DateTimeFormat, $ExampleTimestampVal = "01CD74B3150770B8", $TimestampPrecision
Global $tDelta = _WinTime_GetUTCToLocalFileTimeDelta()

Global $TargetDrive = "", $MFT_Record_Size, $BytesPerCluster, $MFT_Offset, $MFT_Size
Global $FileTree[1], $hDisk, $rBuffer, $NonResidentFlag, $zPath, $sBuffer, $Total, $MFTTree[1]
Global $ADS_Name, $Reparse = ""
Global $DT_Clusters, $DT_InitSize, $DataRun, $DT_DataRun
Global $IsCompressed, $IsSparse, $logfile = 0, $subst, $active = False
Global $RUN_VCN[1], $RUN_Clusters[1], $MFT_RUN_Clusters[1], $MFT_RUN_VCN[1], $DataQ[1], $AttrQ[1]
Global $TargetImageFile, $Entries, $IsImage = False, $ImageOffset=0, $IsMftFile=False, $TargetMftFile
Global $begin, $ElapsedTime, $InitState=1
Global $OverallProgress, $CurrentProgress=-1, $ProgressStatus, $ProgressFileName, $ProgressSize ;$FileProgress
Global $RegExPattern = "[1-9a-fA-F]"

Global Const $RecordSignatureBad = '42414144' ; BAAD signature
Global Const $RecordSignature = '46494C45' ; FILE signature

Global $myctredit, $CheckUnicode, $CheckCsvSplit, $checkFixups, $checkBrokenMFT, $checkBruteForceSlack, $SeparatorInput, $checkquotes, $ComboRecordSize, $sOutputFormat
Global $CommandlineMode
Global $buttonColor = 0xD8D8DF

If $cmdline[0] > 0 Then

	$CommandlineMode = True
	ConsoleWrite($Progversion & @CRLF)

	_GetInputParams()

Else
	DllCall("kernel32.dll", "bool", "FreeConsole")
	$CommandlineMode = False

	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

	$Form = GUICreate($Progversion, 700, 520, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_HandleExit", $Form)

	$ComboPhysicalDrives = GUICtrlCreateCombo("", 200, 10, 350, 20, $CBS_DROPDOWNLIST)
	$buttonScanPhysicalDrives = GUICtrlCreateButton("Scan Physical", 20, 10, 80, 25)
	GUICtrlSetBkColor($buttonScanPhysicalDrives, $buttonColor)
	GUICtrlSetOnEvent($buttonScanPhysicalDrives, "_HandleEvent")
	$buttonScanShadowCopies = GUICtrlCreateButton("Scan Shadows", 110, 10, 80, 25)
	GUICtrlSetBkColor($buttonScanShadowCopies, $buttonColor)
	GUICtrlSetOnEvent($buttonScanShadowCopies, "_HandleEvent")
	$buttonTestPhysicalDrive = GUICtrlCreateButton("<-- Verify Volumes", 570, 10, 110, 25)
	GUICtrlSetBkColor($buttonTestPhysicalDrive, $buttonColor)
	GUICtrlSetOnEvent($buttonTestPhysicalDrive, "_HandleEvent")

	$buttonDrive = GUICtrlCreateButton("Scan Drives", 110, 45, 80, 25)
	GUICtrlSetBkColor($buttonDrive, $buttonColor)
	GUICtrlSetOnEvent($buttonDrive, "_HandleEvent")
	$Combo = GUICtrlCreateCombo("", 200, 45, 350, 20, $CBS_DROPDOWNLIST)

	$checkFixups = GUICtrlCreateCheckbox("Skip Fixups", 430, 70, 95, 20)
	$checkBrokenMFT = GUICtrlCreateCheckbox("Broken $MFT", 430, 90, 95, 20)
	$checkBruteForceSlack = GUICtrlCreateCheckbox("Scan slack", 430, 110, 95, 20)

	GUICtrlCreateLabel("Extract resident:", 350, 140, 80, 20)
	$checkExtractResidentSlack = GUICtrlCreateCheckbox("Slack", 430, 140, 50, 20)
	$checkExtractResidentData = GUICtrlCreateCheckbox("Data", 480, 140, 50, 20)

	$buttonImage = GUICtrlCreateButton("Choose Image", 570, 75, 110, 30)
	GUICtrlSetBkColor($buttonImage, $buttonColor)
	GUICtrlSetOnEvent($buttonImage, "_HandleEvent")
	$buttonMftFile = GUICtrlCreateButton("Choose $MFT", 570, 115, 110, 30)
	GUICtrlSetBkColor($buttonMftFile, $buttonColor)
	GUICtrlSetOnEvent($buttonMftFile, "_HandleEvent")

	GUICtrlCreateLabel("Set output format:", 20, 100, 100, 20)
	$ComboOutputFormat = GUICtrlCreateCombo("", 150, 100, 90, 25, $CBS_DROPDOWNLIST)

	$Label1 = GUICtrlCreateLabel("Timezone configuration:", 20, 130, 120, 20)
	$Combo2 = GUICtrlCreateCombo("", 150, 130, 90, 25, $CBS_DROPDOWNLIST)

	$LabelSeparator = GUICtrlCreateLabel("Separator:", 20, 180, 50, 20)
	$SeparatorInput2 = GUICtrlCreateInput($separator, 80, 180, 30, 20)
	GUICtrlSetState($SeparatorInput2, $GUI_DISABLE)
	$SeparatorInput = GUICtrlCreateInput($separator, 130, 180, 20, 20)

	$LabelRecordSize = GUICtrlCreateLabel("Record size:", 190, 180, 90, 20)
	$ComboRecordSize = GUICtrlCreateCombo("", 270, 180, 50, 20, $CBS_DROPDOWNLIST)

	$checkquotes = GUICtrlCreateCheckbox("Quotation mark", 430, 175, 100, 20)
	GUICtrlSetState($checkquotes, $GUI_UNCHECKED)
	$CheckUnicode = GUICtrlCreateCheckbox("Unicode", 430, 195, 60, 20)
	GUICtrlSetState($CheckUnicode, $GUI_UNCHECKED)
	$CheckCsvSplit = GUICtrlCreateCheckbox("split csv", 430, 215, 60, 20)
	GUICtrlSetState($CheckCsvSplit, $GUI_UNCHECKED)

	$buttonOutput = GUICtrlCreateButton("Set Output Path", 570, 175, 110, 30)
	GUICtrlSetBkColor($buttonOutput, $buttonColor)
	GUICtrlSetOnEvent($buttonOutput, "_HandleEvent")

	$LabelTimestampFormat = GUICtrlCreateLabel("Timestamp format:", 20, 215, 90, 20)
	$ComboTimestampFormat = GUICtrlCreateCombo("", 120, 215, 30, 25, $CBS_DROPDOWNLIST)
	$LabelTimestampPrecision = GUICtrlCreateLabel("Precision:", 190, 215, 50, 20)
	$ComboTimestampPrecision = GUICtrlCreateCombo("", 250, 215, 70, 25, $CBS_DROPDOWNLIST)
	;$LabelTimestampError = GUICtrlCreateLabel("Timestamp ErrorVal:", 330, 215, 110, 20)
	;$TimestampErrorInput = GUICtrlCreateInput($TimestampErrorVal, 440, 210, 130, 20)

	$LabelPrecisionSeparator = GUICtrlCreateLabel("Precision separator:", 20, 255, 100, 20)
	$PrecisionSeparatorInput = GUICtrlCreateInput($PrecisionSeparator, 135, 255, 15, 20)
	$LabelPrecisionSeparator2 = GUICtrlCreateLabel("Precision separator2:", 190, 255, 100, 20)
	$PrecisionSeparatorInput2 = GUICtrlCreateInput($PrecisionSeparator2, 305, 255, 15, 20)

	$InputExampleTimestamp = GUICtrlCreateInput("", 345, 255, 200, 20)
	GUICtrlSetState($InputExampleTimestamp, $GUI_DISABLE)

	$buttonStart = GUICtrlCreateButton("Start Processing", 570, 240, 110, 50)
	GUICtrlSetFont($buttonStart, 8.5,  $FW_SEMIBOLD)
	GUICtrlSetOnEvent($buttonStart, "_HandleEvent")
	GUICtrlSetBkColor($buttonStart, $buttonColor)

	$myctredit = GUICtrlCreateEdit("Decoding $MFT" & @CRLF, 0, 300, 700, 80, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor($myctredit, 0xFFFFFF)

	_GetPhysicalDrives("PhysicalDrive")
	_GetMountedDrivesInfo()
	_InjectTimeZoneInfo()
	_InjectTimestampFormat()
	_InjectTimestampPrecision()
	_TranslateTimestamp()
	_InjectRecordSize()
	_InjectOutputFormat()

	$LogState = True
	GUISetState(@SW_SHOW, $Form)

	While Not $active
		Sleep(50)
		_TranslateSeparator()
		$PrecisionSeparator = GUICtrlRead($PrecisionSeparatorInput)
		$PrecisionSeparator2 = GUICtrlRead($PrecisionSeparatorInput2)
		_TranslateTimestamp()
	WEnd

	$tDelta = _GetUTCRegion(GUICtrlRead($Combo2)) - $tDelta
	If @error Then
		_DisplayInfo("Error: Timezone configuration failed." & @CRLF)
	Else
		_DisplayInfo("Timestamps presented in UTC: " & $UTCconfig & @CRLF)
	EndIf
	$tDelta = $tDelta * -1 ;Since delta is substracted from timestamp later on


	Select
		Case $IsImage
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo), 10), 2)
			_DisplayInfo(@CRLF & "Target is: " & GUICtrlRead($Combo) & @CRLF)
			_DebugOut("Target image file: " & $TargetImageFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetImageFile, 2, 2, 7)
		Case $IsMftFile
			_DebugOut("Target $MFT file: " & $TargetMftFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetMftFile, 2, 2, 7)
			$MftFileSize = _WinAPI_GetFileSizeEx($hDisk)
		Case $IsPhysicalDrive = True
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo), 10), 2)
			_DebugOut("Target is: \\.\" & $TargetImageFile)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetImageFile, 2, 2, 6)
		Case $IsShadowCopy = True
			$TargetDrive = "SC" & StringMid($TargetImageFile, 47)
			$ImageOffset = Int(StringMid(GUICtrlRead($Combo), 10), 2)
			_DebugOut("Target drive is: " & $TargetImageFile)
			_DebugOut("Volume at offset: " & $ImageOffset)
			$hDisk = _WinAPI_CreateFile($TargetImageFile, 2, 2, 6)
		Case Else
			$TargetDrive = StringMid(GUICtrlRead($Combo), 1, 2)
			_DebugOut("Target volume: " & $TargetDrive)
			$hDisk = _WinAPI_CreateFile("\\.\" & $TargetDrive, 2, 2, 6)
	EndSelect

	If $hDisk = 0 Then
		_DebugOut("Error in CreateFile: " & _WinAPI_GetLastErrorMessage())
		Exit(1)
	EndIf

EndIf

; Create output
_CreateOutputStructureAndFiles()

_DebugOut("Timestamps presented in UTC " & $UTCconfig)

; start our timer
Local $hTimer = TimerInit()

; the main processing
_ExtractSystemfile()
If @error Then
	_DisplayWrapper("Parsing failure" & @CRLF)
	If Not $CommandlineMode Then
		MsgBox(0, "Error", "Check the logs for more details")
	EndIf
	Exit(1)
EndIf

Local $fDiff = TimerDiff($hTimer)
_DisplayWrapper("Total processing time is " & _WinAPI_StrFromTimeInterval($fDiff))
If Not $CommandlineMode Then
	; display a last message before application is closed
	MsgBox(0, "Parsing finished", "Job took: " & @CRLF & _WinAPI_StrFromTimeInterval($fDiff) & @CRLF & @CRLF & "Output can be found in: " & @CRLF & $OutputPath)
EndIf
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
			Case $buttonStart
				If $OutputPath="" Then
					_DisplayInfo("Error: No output path selected" & @CRLF)
					Return
				EndIf
				_DebugOut("Dumping output to: " & $OutputPath)
				$active = True
			Case $buttonOutput
				_SetOutputPath()
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

	Global $DataQ[1], $RUN_VCN[1], $RUN_Clusters[1]

	If $CommandlineMode Then
;		$CheckUnicode = $CheckUnicode
;		;$TimestampErrorVal = $TimestampErrorVal
;		$PrecisionSeparator = $PrecisionSeparator
;		$PrecisionSeparator2 = $PrecisionSeparator2
;		$CheckCsvSplit = $CheckCsvSplit
;		$checkFixups = $checkFixups
;		$checkBruteForceSlack = $checkBruteForceSlack
;		$checkBrokenMFT = $checkBrokenMFT
;		$checkExtractResidentData = $checkExtractResidentData
;		$checkExtractResidentSlack = $checkExtractResidentSlack
;		$checkl2t = $checkl2t
;		$checkbodyfile = $checkbodyfile
;		$checkdefaultall = $checkdefaultall
;		$SeparatorInput = $SeparatorInput
;		$checkquotes = $checkquotes
	Else
		$CheckUnicode = GUICtrlRead($CheckUnicode)
		;$TimestampErrorVal = GUICtrlRead($TimestampErrorInput)
		;$TimestampErrorVal = $TimestampErrorVal
		$PrecisionSeparator = GUICtrlRead($PrecisionSeparatorInput)
		$PrecisionSeparator2 = GUICtrlRead($PrecisionSeparatorInput2)
		$CheckCsvSplit = GUICtrlRead($CheckCsvSplit)
		$checkFixups = GUICtrlRead($checkFixups)
		$checkBruteForceSlack = GUICtrlRead($checkBruteForceSlack)
		$checkBrokenMFT = GUICtrlRead($checkBrokenMFT)
		$checkExtractResidentData = GUICtrlRead($checkExtractResidentData)
		$checkExtractResidentSlack = GUICtrlRead($checkExtractResidentSlack)
;		$checkl2t = GUICtrlRead($checkl2t)
;		$checkbodyfile = GUICtrlRead($checkbodyfile)
;		$checkdefaultall = GUICtrlRead($checkdefaultall)
		$sOutputFormat = GUICtrlRead($ComboOutputFormat)
		$SeparatorInput = GUICtrlRead($SeparatorInput)
		$checkquotes = GUICtrlRead($checkquotes)
		$MFT_Record_Size = GUICtrlRead($ComboRecordSize)
	EndIf

	If $CheckUnicode = 1 Then
		$EncodingWhenOpen = 2+128
		_DebugOut("UNICODE configured")
	Else
		$EncodingWhenOpen = 2
		_DebugOut("ANSI configured")
	EndIf

	_DebugOut("Timestamp Precision: " & $TimestampPrecision)

	If StringLen($PrecisionSeparator) <> 1 Then
		If Not $CommandlineMode Then _DisplayInfo("Error: Precision separator not set properly" & @crlf)
		_DebugOut("Error: Precision separator not set properly: " & $PrecisionSeparator)
		Return SetError(1)
	Else
		_DebugOut("Using precision separator: " & $PrecisionSeparator)
	EndIf

	If Not $CommandlineMode Then _TranslateTimestamp()

	If $CheckCsvSplit = 1 Then
		$DoSplitCsv = True
		_DebugOut("Splitting csv")
	EndIf

	If $checkFixups = 1 Then
		$SkipFixups = True
		_DebugOut("Skipping Fixups")
	EndIf

	If $checkBruteForceSlack = 1 Then
		$DoBruteForceSlack = 1
	Else
		$DoBruteForceSlack = 0
	EndIf
	_DebugOut("Scan record slack: " & $DoBruteForceSlack)

	If $checkBrokenMFT = 1 Then
		$MftIsBroken = True
		_DebugOut("Handling broken $MFT")
	EndIf

	If $checkExtractResidentData = 1 Then
		$ExtractResidentData = True
		_DebugOut("Extracting resident data")
	EndIf
	If $checkExtractResidentSlack = 1 Then
		$ExtractResidentSlack = True
		_DebugOut("Extracting resident slack")
	EndIf

	Select
		Case $sOutputFormat = "all"
			$DoDefaultAll = True
		Case $sOutputFormat = "bodyfile"
			$DoBodyfile = True
		Case $sOutputFormat = "log2timeline"
			$Dol2t = True
		Case Else
			_DebugOut("Error: unexpected output format: " & $sOutputFormat)
			Return SetError(1)
	EndSelect

	If StringLen($SeparatorInput) <> 1 Then
		If Not $CommandlineMode Then _DisplayInfo("Error: Separator not set properly" & @crlf)
		_DebugOut("Error: Separator not set properly: " & $SeparatorInput)
		Return SetError(1)
	Else
		$de = $SeparatorInput
		_DebugOut("Using separator: " & $de)
	EndIf

	If $checkquotes = 1 Then
		_DebugOut("Writing variables surrounded with qoutes")
	Else
		_DebugOut("Writing variables without surrounding qoutes")
	EndIf

	If (Not $IsImage and Not $IsMftFile and Not $IsShadowCopy) Then
		If DriveGetFileSystem($TargetDrive) <> "NTFS" Then		;read boot sector and extract $MFT data
			If Not $CommandlineMode Then _DisplayInfo("Error: Target volume " & $TargetDrive & " is not NTFS" & @crlf)
			Return SetError(1)
		EndIf
		If Not $CommandlineMode Then _DisplayInfo("Target volume is: " & $TargetDrive & @crlf)
	EndIf

	If Not $IsMftFile Then
		_WinAPI_SetFilePointerEx($hDisk, $ImageOffset, $FILE_BEGIN)
		$BootRecord = _GetDiskConstants()
		If $BootRecord = "" Then
			_DebugOut("Unable to read Boot Sector")
			Return SetError(1)
		EndIf
	Else
		If $MFT_Record_Size <> 1024 And $MFT_Record_Size <> 4096 Then
			_DebugOut("Bad mft record size: " & $MFT_Record_Size)
			Return SetError(1)
		EndIf
		$BytesPerCluster = 512 * 8
		$MFT_Offset = 0
		$ClustersPerFileRecordSegment = Ceiling($MFT_Record_Size/$BytesPerCluster)
	EndIf
	_DebugOut("Using record size: " & $MFT_Record_Size)

	$rBuffer = DllStructCreate("byte[" & $MFT_Record_Size & "]")     ;buffer for records

	$MFT = _ReadMFT()
	If $MFT = "" And Not $MftIsBroken Then Return SetError(1)		;something wrong with record for $MFT

	$MFT = _DecodeMFTRecord0($MFT, 0)        ;produces DataQ for $MFT, record 0
	If $MFT = "" And Not $MftIsBroken Then Return SetError(1)

	_GetRunsFromAttributeListMFT0() ;produces datarun for $MFT and converts datarun to RUN_VCN[] and RUN_Clusters[]

	$MFT_Size = $DT_RealSize

	If ($IsMftFile Or $MftIsBroken) Then
		; no need to deal with real clusters when input is standalone file
		$RUN_VCN[1] = 1
		$RUN_Clusters[1] = Int(((512 + $MftFileSize - Mod($MftFileSize, 512)) / 512 / 8))
		ReDim $RUN_VCN[2]
		ReDim $RUN_Clusters[2]
	EndIf
	$MFT_RUN_VCN = $RUN_VCN
	$MFT_RUN_Clusters = $RUN_Clusters	;preserve values for $MFT

	$Progress = GUICtrlCreateLabel("Decoding $MFT info and writing to csv", 20, 385, 540, 20)
	GUICtrlSetFont($Progress, 12)
	$ProgressStatus = GUICtrlCreateLabel("", 20, 415, 660, 20)
	$ElapsedTime = GUICtrlCreateLabel("", 20, 430, 660, 20)
	$OverallProgress = GUICtrlCreateProgress(20, 455, 660, 30)

	If Not $MftIsBroken Then
		_DoFileTree()                        ;creates folder structure
	Else
		$Total = ($MftFileSize/$MFT_Record_Size)
		Redim $FileTree[$Total]
	EndIf

	$ProgressFileName = GUICtrlCreateLabel("", 20,  495, 660, 20, $DT_END_ELLIPSIS)
	;$FileProgress = GUICtrlCreateProgress(20, 520, 660, 30)
	AdlibRegister("_ExtractionProgress", 500)

	$begin = TimerInit()
	Local $nBytes

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
		If (StringMid($MFTEntry, 3, 8) = $RecordSignature) Then
			$Signature = "GOOD"
		ElseIf (StringMid($MFTEntry, 3, 8) = $RecordSignatureBad) Then
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
		$RecordOffset = "0x" & Hex($RecordOffsetDec)
		If $ExtractResidentData Then
			_ExtractSingleFile($MFTEntry, $i)
		EndIf
		_ClearVar()
		$RecordOffset = "0x" & Hex($RecordOffsetDec)
		_ParserCodeOldVersion($MFTEntry)
		If $DT_Number > 0 Then $ADS = $DT_Number - 1
		;$RecordOffset = "0x" & Hex($RecordOffsetDec)
		$CTimeTest = _Test_SI2FN_CTime()
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

	; only check line count for smaller sized output
	If Not FileGetSize($RBICsvFile) > 100000 Then
		If (_FileCountLines($RBICsvFile) < 2) Then
			FileMove($RBICsvFile,$RBICsvFile&".empty",1)
			_DebugOut("Empty output: " & $RBICsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($I30EntriesCsvFile) > 100000 Then
		If (_FileCountLines($I30EntriesCsvFile) < 2) Then
			FileMove($I30EntriesCsvFile,$I30EntriesCsvFile&".empty",1)
			_DebugOut("Empty output: " & $I30EntriesCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($NewI30EntriesCsvFile) > 100000 Then
		If (_FileCountLines($NewI30EntriesCsvFile) < 2) Then
			FileMove($NewI30EntriesCsvFile,$NewI30EntriesCsvFile&".empty",1)
			_DebugOut("Empty output: " & $NewI30EntriesCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($EntriesObjectIdCsvFile) > 100000 Then
		If (_FileCountLines($EntriesObjectIdCsvFile) < 2) Then
			FileMove($EntriesObjectIdCsvFile,$EntriesObjectIdCsvFile&".empty",1)
			_DebugOut("Empty output: " & $EntriesObjectIdCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($ReparsePointCsvFile) > 100000 Then
		If (_FileCountLines($ReparsePointCsvFile) < 2) Then
			FileMove($ReparsePointCsvFile,$ReparsePointCsvFile&".empty",1)
			_DebugOut("Empty output: " & $ReparsePointCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($ReparsePointAppExecLinkCsvFile) > 100000 Then
		If (_FileCountLines($ReparsePointAppExecLinkCsvFile) < 2) Then
			FileMove($ReparsePointAppExecLinkCsvFile,$ReparsePointAppExecLinkCsvFile&".empty",1)
			_DebugOut("Empty output: " & $ReparsePointAppExecLinkCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($EaCsvFile) > 100000 Then
		If (_FileCountLines($EaCsvFile) < 2) Then
			FileMove($EaCsvFile,$EaCsvFile&".empty",1)
			_DebugOut("Empty output: " & $EaCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($LoggedUtilityStreamCsvFile) > 100000 Then
		If (_FileCountLines($LoggedUtilityStreamCsvFile) < 2) Then
			FileMove($LoggedUtilityStreamCsvFile,$LoggedUtilityStreamCsvFile&".empty",1)
			_DebugOut("Empty output: " & $LoggedUtilityStreamCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($LoggedUtilityStreamTxfDataCsvFile) > 100000 Then
		If (_FileCountLines($LoggedUtilityStreamTxfDataCsvFile) < 2) Then
			FileMove($LoggedUtilityStreamTxfDataCsvFile,$LoggedUtilityStreamTxfDataCsvFile&".empty",1)
			_DebugOut("Empty output: " & $LoggedUtilityStreamTxfDataCsvFile & " is postfixed with .empty")
		EndIf
	EndIf
	If Not FileGetSize($AdditionalDataCsvFile) > 100000 Then
		If (_FileCountLines($AdditionalDataCsvFile) < 2) Then
			FileMove($AdditionalDataCsvFile,$AdditionalDataCsvFile&".empty",1)
			_DebugOut("Empty output: " & $AdditionalDataCsvFile & " is postfixed with .empty")
		EndIf
	EndIf

	_DisplayWrapper("Finished processing " & $Total & " records" & @CRLF)

EndFunc

Func _DoFileTree()
	Local $nBytes, $ParentRef, $FileRef, $BaseRef, $testvar=0, $TmpRecord, $MFTClustersToKeep=0, $DoKeepCluster=0, $Subtr, $PartOfAttrList=0, $ArrSize
	$Total = Int($MFT_Size/$MFT_Record_Size)
	Global $FileTree[$Total]
	Global $MFTTree[$Total]
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
					#cs
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
					#ce
				EndIf
				$Offset += $Size*2
			WEnd
			If Not BitAND($Flags,Dec("0200")) And $PartOfAttrList=0 And $FileTree[$FileRef] <> "" Then $FileTree[$FileRef] &= "?" & ($Pos + $i)     ;file also add FilePointer
			If StringInStr($FileTree[$FileRef], "**") = 1 Then $FileTree[$FileRef] = StringTrimLeft($FileTree[$FileRef],2)    ;remove leading **
			If $i = 0 And $DoKeepCluster Then $FileTree[$FileRef] &= "/" & $ArrSize  ;Mark record as being split across 2 runs
		Next
	Next
	AdlibUnRegister()
	If UBound($FileTree) > 5 Then
		$FileTree[5] = ":"
	EndIf
	$begin = TimerInit()
	AdlibRegister("_FolderStrucProgress", 500)
	For $i = 0 to UBound($FileTree)-1
		$CurrentProgress = $i
		If StringInStr($FileTree[$i], "**") = 0 Then
			While StringInStr($FileTree[$i], "*") > 0   ;single file
				$Parent=StringMid($Filetree[$i], 1, StringInStr($FileTree[$i], "*")-1)
;				_DebugOut("$Parent: " & $Parent)
				If $Parent < UBound($Filetree) Then
					If StringInStr($Filetree[$Parent],"?")=0 And (StringInStr($Filetree[$Parent],"*")>0 Or StringInStr($Filetree[$Parent],":")>0) Then
						$FileTree[$i] = StringReplace($FileTree[$i], $Parent & "*", $Filetree[$Parent] & "\")
					Else
						$FileTree[$i] = StringReplace($FileTree[$i], $Parent & "*", $Filetree[5] & "\ORPHAN\")
					EndIf
				Else
					_DebugOut("Error: $Parent out of bounds: " & $Parent)
					ExitLoop
				EndIf
			WEnd
		Else
			$Names = StringSplit($FileTree[$i], "**",3)     ;hard links
			$str = ""
			For $n = 0 to UBound($Names) - 1
				While StringInStr($Names[$n], "*") > 0
;					_DebugOut("$Names[$n]: " & $Names[$n])
					$Parent=StringMid($Names[$n], 1, StringInStr($Names[$n], "*")-1)
;					_DebugOut("$Parent: " & $Parent)
					If $Parent < UBound($Filetree) Then
						If StringInStr($Filetree[$Parent],"?")=0 And (StringInStr($Filetree[$Parent],"*")>0 Or StringInStr($Filetree[$Parent],":")>0) Then
							$Names[$n] = StringReplace($Names[$n], $Parent & "*", $Filetree[$Parent] & "\")
						Else
							$Names[$n] = StringReplace($Names[$n], $Parent & "*", $Filetree[5] & "\ORPHAN\")
						EndIf
					Else
						_DebugOut("Error: $Parent out of bounds: " & $Parent)
						ExitLoop
					EndIf
				WEnd
				$str &= $Names[$n] & "*"
			Next
			$FileTree[$i] = StringTrimRight($str,1)
		EndIf
	Next
	If UBound($FileTree) > 5 Then
		$FileTree[5] &= "\"
	EndIf
	AdlibUnRegister()
	For $i = 0 To UBound($FileTree) - 1
		If StringInStr($FileTree[$i], "*") = 0 Then
			ContinueLoop
		EndIf
		$myarr = StringSplit($FileTree[$i], "*")
		_ArrayDelete($myarr, 0)
		_ArraySort($myarr, 0)
		$testvar = ""
		For $j = 0 To UBound($myarr) - 1
			$testvar &= $myarr[$j] & "*"
		Next
		;_DebugOut("Sorted: " & $testvar)
		$FileTree[$i] = StringTrimRight($testvar, 1)
	Next
EndFunc

Func _DecodeAttrList($FileRef, $AttrList)
   Local $offset, $nBytes, $List = "", $str = ""
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
				$FN_Name = $FileName
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
	If $SectorsPerCluster > 0x80 Then
		; 0xf8 -> 256, 0xf7 -> 512, 0xf6 -> 1024, 0xf5 -> 2048, 0xf4 -> 4096, etc
		Local $TmpVal = Dec(StringRight(Hex(BitNOT($SectorsPerCluster), 8), 2))
		$SectorsPerCluster = BitShift(1, ($TmpVal + 1) * -1)
	EndIf
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
	EndIf
	$ClustersPerFileRecordSegment = Ceiling($MFT_Record_Size/$BytesPerCluster)
   Return $record
EndFunc

Func _DisplayInfo($DebugInfo)
   _GUICtrlEdit_AppendText($myctredit, $DebugInfo)
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
	;GUICtrlSetData($FileProgress, 100 * ($DT_RealSize - $ProgressSize) / $DT_RealSize)
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

Func _ResolveMftFlags($value)
	; regular file/folder
	Select
		Case $value = 0 Or $value = 1
			Return "FILE"
		Case $value = 2 Or $value = 2
			Return "FOLDER"
	EndSelect
	; other
	Local $sOutput
	If BitAND($value, 0x0002) Then
		$sOutput &= 'FOLDER+'
	Else
		$sOutput &= 'FILE+'
	EndIf
	; then add..
	If BitAND($value, 0x0004) Then $sOutput &= 'EXTEND+'
	If BitAND($value, 0x0008) Then $sOutput &= 'INDEX+'
	; trim output
	If StringLen($sOutput) = 0 Then Return
	$sOutput = StringTrimRight($sOutput, 1)
	Return $sOutput
EndFunc

Func _ActiveOrDeleted($value)
	If BitAND($value, 0x0001) Then
		Return 'ALLOCATED'
	Else
		Return 'DELETED'
	EndIf
EndFunc

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
	Local $UpdSeqArrPart0, $UpdSeqArrPart1, $UpdSeqArrPart2, $RecordEnd1, $RecordEnd2

	If $MFT_Record_Size = 1024 Then
		$UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		$UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		$UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		$RecordEnd1 = StringMid($MFTEntry,1023,4)
		$RecordEnd2 = StringMid($MFTEntry,2047,4)
		If $RecordEnd1 <> $RecordEnd2 Or $UpdSeqArrPart0 <> $RecordEnd1 Then
			$IntegrityCheck = "BAD"
		Else
			$IntegrityCheck = "OK"
		EndIf
		$MFTEntry = StringMid($MFTEntry,1,1022) & $UpdSeqArrPart1 & StringMid($MFTEntry,1027,1020) & $UpdSeqArrPart2
	ElseIf $MFT_Record_Size = 4096 Then
		$UpdSeqArrPart0 = StringMid($UpdSeqArr,1,4)
		$UpdSeqArrPart1 = StringMid($UpdSeqArr,5,4)
		$UpdSeqArrPart2 = StringMid($UpdSeqArr,9,4)
		Local $UpdSeqArrPart3 = StringMid($UpdSeqArr,13,4)
		Local $UpdSeqArrPart4 = StringMid($UpdSeqArr,17,4)
		Local $UpdSeqArrPart5 = StringMid($UpdSeqArr,21,4)
		Local $UpdSeqArrPart6 = StringMid($UpdSeqArr,25,4)
		Local $UpdSeqArrPart7 = StringMid($UpdSeqArr,29,4)
		Local $UpdSeqArrPart8 = StringMid($UpdSeqArr,33,4)
		$RecordEnd1 = StringMid($MFTEntry,1023,4)
		$RecordEnd2 = StringMid($MFTEntry,2047,4)
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
	$HDR_Flags = Dec(_SwapEndian($HDR_Flags))
	$RecordActive = _ActiveOrDeleted($HDR_Flags)
	$HDR_Flags = _ResolveMftFlags($HDR_Flags)

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
	Local $attrCounter=0
	While $AttributeKnown = 1
		$attrCounter += 1
		$NextAttributeType = StringMid($MFTEntry, $NextAttributeOffset, 8)
		$AttributeType = $NextAttributeType
		$AttributeSize = StringMid($MFTEntry, $NextAttributeOffset + 8, 8)
		$AttributeSize = Dec(_SwapEndian($AttributeSize),2)
		Select
			Case $AttributeType = $STANDARD_INFORMATION
				$AttributeKnown = 1
				$SI_ON = 1
				_Get_StandardInformation($MFTEntry, $NextAttributeOffset)

			Case $AttributeType = $ATTRIBUTE_LIST
				$AttributeKnown = 1
				$AL_ON = 1
				;			_Get_AttributeList()

			Case $AttributeType = $FILE_NAME
				$AttributeKnown = 1
				$FN_ON = 1
				$FN_Number += 1 ; Need to come up with something smarter than this
				If $FN_Number > 4 Then
;					_DebugOut("Warning: Ref " & $HDR_MFTREcordNumber & " had $FILE_NAME number " & $FN_Number & " not decoded","0x"&StringMid($MFTEntry,$NextAttributeOffset,$AttributeSize*2))
					_DebugOut("Warning: Ref " & $HDR_MFTREcordNumber & " had $FILE_NAME number " & $FN_Number & " not decoded")
				Else
					_Get_FileName($MFTEntry, $NextAttributeOffset, $FN_Number)
				EndIf

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
				If $DoDefaultAll Then _Get_VolumeInformation($MFTEntry, $NextAttributeOffset)

			Case $AttributeType = $DATA
				$AttributeKnown = 1
				$DT_ON = 1
				$DT_Number += 1
				_Get_AdditionalData($MFTEntry, $NextAttributeOffset, $AttributeSize, $DT_Number)
				If $DT_Number > 3 Then
					;_Get_AdditionalData($MFTEntry, $NextAttributeOffset, $AttributeSize, $DT_Number)
					_DebugOut("Warning: Ref " & $HDR_MFTREcordNumber & " had $DATA number " & $DT_Number & " not decoded","0x"&StringMid($MFTEntry,$NextAttributeOffset,$AttributeSize*2))
				Else
					_Get_Data($MFTEntry, $NextAttributeOffset, $AttributeSize, $DT_Number)
				EndIf

			Case $AttributeType = $INDEX_ROOT
				$AttributeKnown = 1
				$IR_ON = 1
				$CoreAttr = _GetAttributeEntry(StringMid($MFTEntry, $NextAttributeOffset, $AttributeSize*2))
				$CoreAttrChunk = $CoreAttr[0]
				$CoreAttrName = $CoreAttr[1]
				If $CoreAttrName = "$I30" Then
					_Get_IndexRoot($CoreAttrChunk, 1)
				EndIf

			Case $AttributeType = $INDEX_ALLOCATION
				$AttributeKnown = 1
				$IA_ON = 1
				_GetAttributeEntry(StringMid($MFTEntry, $NextAttributeOffset, $AttributeSize*2))
				;			_Get_IndexAllocation()

			Case $AttributeType = $BITMAP
				$AttributeKnown = 1
				$BITMAP_ON = 1
				;			_Get_Bitmap()

			Case $AttributeType = $REPARSE_POINT
				$AttributeKnown = 1
				$RP_ON = 1
				_Get_ReparsePoint($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $EA_INFORMATION
				$AttributeKnown = 1
				$EAI_ON = 1
				;			_Get_EaInformation()

			Case $AttributeType = $EA
				$AttributeKnown = 1
				$EA_ON = 1
				_Get_Ea($MFTEntry, $NextAttributeOffset, $AttributeSize)

			Case $AttributeType = $PROPERTY_SET
				$AttributeKnown = 1
				$PS_ON = 1
				;			_Get_PropertySet()

			Case $AttributeType = $LOGGED_UTILITY_STREAM
				$AttributeKnown = 1
				$LUS_ON = 1
				$CoreAttr = _GetAttributeEntry(StringMid($MFTEntry, $NextAttributeOffset, $AttributeSize*2))
				$CoreAttrChunk = $CoreAttr[0]
				$CoreAttrName = $CoreAttr[1]
;				If $CoreAttrChunk <> "" Then
					_Get_LoggedUtilityStream($CoreAttrChunk, $CoreAttrName)
;				EndIf

			Case $AttributeType = $ATTRIBUTE_END_MARKER
				$AttributeKnown = 0
				ExitLoop
;				ConsoleWrite("No more attributes in this record." & @CRLF)

			Case $AttributeType <> $LOGGED_UTILITY_STREAM And $AttributeType <> $EA And $AttributeType <> $EA_INFORMATION And $AttributeType <> $REPARSE_POINT And $AttributeType <> $BITMAP And $AttributeType <> $INDEX_ALLOCATION And $AttributeType <> $INDEX_ROOT And $AttributeType <> $DATA And $AttributeType <> $VOLUME_INFORMATION And $AttributeType <> $VOLUME_NAME And $AttributeType <> $SECURITY_DESCRIPTOR And $AttributeType <> $OBJECT_ID And $AttributeType <> $FILE_NAME And $AttributeType <> $ATTRIBUTE_LIST And $AttributeType <> $STANDARD_INFORMATION And $AttributeType <> $PROPERTY_SET And $AttributeType <> $ATTRIBUTE_END_MARKER
				$AttributeKnown = 0
				ExitLoop
;				ConsoleWrite("Unknown attribute found in this record." & @CRLF)

			Case Else
				;$AttributeSize = 0
				;ExitLoop

		EndSelect

		If $attrCounter > 50 Then
			ExitLoop
		EndIf

		$NextAttributeOffset = $NextAttributeOffset + ($AttributeSize * 2)
	WEnd
	If $ExtractResidentSlack Then
		Local $tmpName = StringLen($FN_Name_2) > StringLen($FN_Name) ? $FN_Name_2 : $FN_Name
		;ConsoleWrite("Extracting slack for mftref " & $HDR_MFTREcordNumber & " name " & $tmpName & @CRLF)
		_ExtractSlack(StringMid($MFTEntry, $NextAttributeOffset + 8), $tmpName, $HDR_MFTREcordNumber)
	EndIf
	If $DoBruteForceSlack Then
		_Get_SlackSpace($MFTEntry, $NextAttributeOffset, $IA_ON)
	EndIf
EndFunc

Func _ExtractSlack($data, $name, $mftref)
	Local $hFile, $nBytes, $binlength = StringLen($data)/2
	Local $buff = DllStructCreate("byte[" & $binlength & "]")
	DllStructSetData($buff, 1, "0x" & $data)

	If $RecordOffset <> "" Then
		$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\[" & $RecordOffset & "]" & $name & ".slack", 3, 6, 7)
	Else
		$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\[__" & Hex(Random(1000000, 2000000, 1), 8) & "]" & $name & ".slack", 3, 6, 7)
	EndIf
	If Not $hFile Then
		_DebugOut("Error: Could not create file for slack data for mftref " & $mftref & " name " & $name & " at offset " & $RecordOffset)
	EndIf
	_WinAPI_SetFilePointer($hFile, 0,$FILE_BEGIN)
    _WinAPI_WriteFile($hFile, DllStructGetPtr($buff), $binlength, $nBytes)
	_WinAPI_CloseHandle($hFile)
EndFunc

Func _Get_SlackSpace($MFTEntry, $SS_Offset, $IA_ON)
	Local $SlackBytes = StringMid($MFTEntry,$SS_Offset+8)
	Local $slackLength = StringLen($SlackBytes)
	If $slackLength = 0 Then
;		ConsoleWrite("Warning: No slack detected" & @CRLF)
;		ConsoleWrite("$SS_Offset: " & $SS_Offset & @CRLF)
		Return
	EndIf

	If Not StringRegExp($SlackBytes,$RegExPattern) Then Return

	If $IA_ON Then
		_ScanModeI30ProcessPage($SlackBytes, 1)
		Return
	EndIf

	If _Brute_I30($SlackBytes,$SS_Offset+8) Then Return
	;Check for old $I files from Recycle Bin
	If _Brute_RBI($SlackBytes,$SS_Offset+8) Then Return
	;_DebugOut("Unknown Slack in MftRef " & $HDR_MFTREcordNumber & ":","0x" & $SlackBytes)
EndFunc

Func _Brute_RBI($InputData,$SkeewedOffset)
	Local $TextInformation,$SuccessCounter=0,$SS_RecordOffset,$SS_NameLengthMin=4,$NameTest2
	Local $LocalOffset = 1, $Counter=0,$FileNameHealthy=0
	;Local $DummyPrependBytes = "000000000000000000000000000000000000000000000000" ;24 bytes
	Local $DummyPrependBytes = "00000000000000000000000000000000" ;16 bytes
	Local $VolumeSize=1073741824 ;1GB
	Local $VolumeSizeAdjustment=1048576 ;Accomodate for NTFS systemfiles etc; 1MB
	$InputSize = StringLen($InputData)
	If Not ($InputSize >= 528*2) Then Return $SuccessCounter
;	$RegExPattern = "[1-9a-fA-F]"
;	If Not StringRegExp($InputData,$RegExPattern) Then Return $SuccessCounter
	;_DebugOut("_Brute_RBI():","0x"&$InputData)
	;ConsoleWrite("_Brute_RBI():" & @CRLF)
	;ConsoleWrite(_HexEncode("0x" & $InputData) & @CRLF)
	;ConsoleWrite(_HexEncode($InputData) & @CRLF)
	;Workoaround to catch partly overwritten entries
	If ($InputSize < 528*2) Then
		$InputData = $DummyPrependBytes & $InputData
	EndIf
	While 1
		$Counter+=1
		$FileNameHealthy=0
		$SS_RecordOffset = "0x" & Hex(Int($RecordOffsetDec + (($SkeewedOffset+$LocalOffset-1)/2)))
		$SS_Unknown1 = StringMid($InputData,$LocalOffset,16)
		$SS_Unknown1 = Dec(_SwapEndian($SS_Unknown1),2)
		$SS_FileSize = StringMid($InputData,$LocalOffset+16,16)
		$SS_FileSize = Dec(_SwapEndian($SS_FileSize),2)

		$SS_Timestamp = StringMid($InputData,$LocalOffset+32,16)
		$SS_Timestamp = _SwapEndian($SS_Timestamp)
		$SS_TimestampTest = Dec($SS_Timestamp,2)
		$SS_Timestamp_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SS_Timestamp)
		$SS_Timestamp = _WinTime_UTCFileTimeFormat(Dec($SS_Timestamp,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$SS_Timestamp = $TimestampErrorVal
		ElseIf $TimestampPrecision = 3 Then
			$SS_Timestamp = $SS_Timestamp & $PrecisionSeparator2 & _FillZero(StringRight($SS_Timestamp_tmp, 4))
		EndIf
		;$SS_FileName = StringMid($InputData,$LocalOffset+48,16)
		$SS_FileNameHex = StringMid($InputData,$LocalOffset+48,$SS_NameLengthMin*4)

		$NameTest2 = _ValidateMinimumFileName($SS_FileNameHex)
		If $NameTest2 Then
			$FileNameHealthy = 1
		Endif

		If $NameTest2 Then
			$SS_FileName = _ValidateCompleteName(StringMid($InputData,$LocalOffset+48))
		EndIf
		If $LocalOffset >= StringLen($InputData) Then ExitLoop

		If $FileNameHealthy Then
			$SuccessCounter+=1
			If ($SS_Unknown1 <> 1) Then $TextInformation &= ";Invalid Unknown1"
			If Not ($SS_FileSize < $VolumeSize-$VolumeSizeAdjustment) Then $TextInformation &= ";Invalid FileSize"
			If $SS_Timestamp=$TimestampErrorVal Then $TextInformation &= ";Invalid Timestamp"
			If $SS_TimestampTest < 112589990684262400 Or $SS_TimestampTest > 139611588448485376 Then ;14 oktober 1957 - 31 mai 2043
				$TextInformation &= ";Timestamp out of range"
			EndIf
			FileWriteLine($RBICsv, $SS_RecordOffset & $de & $HDR_MFTREcordNumber & $de & $SS_FileName & $de & $SS_FileSize & $de & $SS_Timestamp & $de & $TextInformation & @crlf)
			ExitLoop
		Else
			$LocalOffset += 2
			;Check if there's any point in parsing the remaining bytes
			If Mod($Counter,16) = 0 Then
				If Not StringRegExp(StringMid($InputData,$LocalOffset),$RegExPattern) Then Return $SuccessCounter
			EndIf
		EndIf
	WEnd
	Return $SuccessCounter
EndFunc

Func _Brute_I30($InputData,$SkeewedOffset)
	Local $SkipUnicodeNames=1,$TextInformation,$SS_MFTReference,$SS_MFTReferenceSeqNo,$SS_MFTReferenceOfParent,$SS_MFTReferenceOfParentSeqNo,$SuccessCounter=0,$SS_RecordOffset
	Local $LocalOffset = 1, $Counter=0
;	ConsoleWrite("_Brute_I30():" & @CRLF)
;	ConsoleWrite(_HexEncode("0x" & $InputData) & @CRLF)
	;Workaround to catch partly overwritten entries
	$InputData = $DummyPrependBytes & $InputData
	While 1
		$Counter+=1
		$FileNameHealthy=0
		$SS_RecordOffset = "0x" & Hex(Int($RecordOffsetDec + (($SkeewedOffset+$LocalOffset-1)/2)))
		$SS_MFTReference = StringMid($InputData,$LocalOffset,12)
		$SS_MFTReference = Dec(_SwapEndian($SS_MFTReference),2)
		$SS_MFTReferenceSeqNo = StringMid($InputData,$LocalOffset+12,4)
		$SS_MFTReferenceSeqNo = Dec(_SwapEndian($SS_MFTReferenceSeqNo),2)
		$SS_IndexEntryLength = StringMid($InputData,$LocalOffset+16,4)
		$SS_IndexEntryLength = Dec(_SwapEndian($SS_IndexEntryLength),2)
		$OffsetToFileName = StringMid($InputData,$LocalOffset+20,4)
		$OffsetToFileName = Dec(_SwapEndian($OffsetToFileName),2)
		$SS_IndexFlags = StringMid($InputData,$LocalOffset+24,4)
;		$Padding = StringMid($InputData,$LocalOffset+28,4)
		$SS_MFTReferenceOfParent = StringMid($InputData,$LocalOffset+32,12)
		$SS_MFTReferenceOfParent = Dec(_SwapEndian($SS_MFTReferenceOfParent),2)
		$SS_MFTReferenceOfParentSeqNo = StringMid($InputData,$LocalOffset+44,4)
		$SS_MFTReferenceOfParentSeqNo = Dec(_SwapEndian($SS_MFTReferenceOfParentSeqNo),2)


		$SS_Indx_CTime = StringMid($InputData, $LocalOffset + 48, 16)
		$SS_Indx_CTime = _SwapEndian($SS_Indx_CTime)
		$SS_Indx_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SS_Indx_CTime)
		$SS_Indx_CTime = _WinTime_UTCFileTimeFormat(Dec($SS_Indx_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$SS_Indx_CTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 3 Then
			$SS_Indx_CTime = $SS_Indx_CTime & $PrecisionSeparator2 & _FillZero(StringRight($SS_Indx_CTime_tmp, 4))
		EndIf
		;
		$SS_Indx_ATime = StringMid($InputData, $LocalOffset + 64, 16)
		$SS_Indx_ATime = _SwapEndian($SS_Indx_ATime)
		$SS_Indx_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SS_Indx_ATime)
		$SS_Indx_ATime = _WinTime_UTCFileTimeFormat(Dec($SS_Indx_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$SS_Indx_ATime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 3 Then
			$SS_Indx_ATime = $SS_Indx_ATime & $PrecisionSeparator2 & _FillZero(StringRight($SS_Indx_ATime_tmp, 4))
		EndIf
		;
		$SS_Indx_MTime = StringMid($InputData, $LocalOffset + 80, 16)
		$SS_Indx_MTime = _SwapEndian($SS_Indx_MTime)
		$SS_Indx_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SS_Indx_MTime)
		$SS_Indx_MTime = _WinTime_UTCFileTimeFormat(Dec($SS_Indx_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$SS_Indx_MTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 3 Then
			$SS_Indx_MTime = $SS_Indx_MTime & $PrecisionSeparator2 & _FillZero(StringRight($SS_Indx_MTime_tmp, 4))
		EndIf
		;
		$SS_Indx_RTime = StringMid($InputData, $LocalOffset + 96, 16)
		$SS_Indx_RTime = _SwapEndian($SS_Indx_RTime)
		$SS_Indx_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $SS_Indx_RTime)
		$SS_Indx_RTime = _WinTime_UTCFileTimeFormat(Dec($SS_Indx_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
		If @error Then
			$SS_Indx_RTime = $TimestampErrorVal
		ElseIf $TimestampPrecision = 3 Then
			$SS_Indx_RTime = $SS_Indx_RTime & $PrecisionSeparator2 & _FillZero(StringRight($SS_Indx_RTime_tmp, 4))
		EndIf
		;
		$SS_Indx_AllocSize = StringMid($InputData,$LocalOffset+112,16)
		$SS_Indx_AllocSize = Dec(_SwapEndian($SS_Indx_AllocSize),2)
		$SS_Indx_RealSize = StringMid($InputData,$LocalOffset+128,16)
		$SS_Indx_RealSize = Dec(_SwapEndian($SS_Indx_RealSize),2)
		$SS_Indx_File_Flags = StringMid($InputData,$LocalOffset+144,8)
		$SS_Indx_File_Flags = _SwapEndian($SS_Indx_File_Flags)
		$SS_Indx_File_Flags = _File_Attributes("0x" & $SS_Indx_File_Flags)
		$SS_Indx_ReparseTag = StringMid($InputData,$LocalOffset+152,8)
		$SS_Indx_ReparseTag = _SwapEndian($SS_Indx_ReparseTag)
		$SS_Indx_ReparseTag = _GetReparseType("0x"&$SS_Indx_ReparseTag)
		$SS_Indx_NameLength = StringMid($InputData,$LocalOffset+160,2)
		$SS_Indx_NameLength = Dec($SS_Indx_NameLength)
		$SS_Indx_NameSpace = StringMid($InputData,$LocalOffset+162,2)
		Select
			Case $SS_Indx_NameSpace = "00"	;POSIX
				$SS_Indx_NameSpace = "POSIX"
			Case $SS_Indx_NameSpace = "01"	;WIN32
				$SS_Indx_NameSpace = "WIN32"
			Case $SS_Indx_NameSpace = "02"	;DOS
				$SS_Indx_NameSpace = "DOS"
			Case $SS_Indx_NameSpace = "03"	;DOS+WIN32
				$SS_Indx_NameSpace = "DOS+WIN32"
			Case Else
				$SS_Indx_NameSpace = "Unknown"
		EndSelect
		$SS_Indx_FileNameHex = StringMid($InputData,$LocalOffset+164,$SS_Indx_NameLength*4)

		If $SkipUnicodeNames Then
			$NameTest = (_ValidateAnsiName($SS_Indx_FileNameHex) And _ValidateWindowsFileName($SS_Indx_FileNameHex))
		Else
			$NameTest = _ValidateWindowsFileName($SS_Indx_FileNameHex)
		EndIf
		If $NameTest Then
			$SS_Indx_FileName = BinaryToString("0x"&$SS_Indx_FileNameHex,2)
			$FileNameHealthy = 1
		Else
;			ConsoleWrite("Error in filename: " & @CRLF)
;			ConsoleWrite("$SS_Indx_FileNameHex: " & $SS_Indx_FileNameHex & @CRLF)
;			ConsoleWrite("$SS_Indx_FileName: " & $SS_Indx_FileName & @CRLF)
		EndIf
		#cs
		ConsoleWrite(@CRLF & "--  " & $Counter & @CRLF)
		ConsoleWrite("$SS_MFTReference: " & $SS_MFTReference & @CRLF)
		ConsoleWrite("$SS_MFTReferenceSeqNo: " & $SS_MFTReferenceSeqNo & @CRLF)
		ConsoleWrite("$SS_MFTReferenceOfParent: " & $SS_MFTReferenceOfParent & @CRLF)
		ConsoleWrite("$SS_MFTReferenceOfParentSeqNo: " & $SS_MFTReferenceOfParentSeqNo & @CRLF)
		ConsoleWrite("$SS_Indx_CTime: " & $SS_Indx_CTime & @CRLF)
		ConsoleWrite("$SS_Indx_ATime: " & $SS_Indx_ATime & @CRLF)
		ConsoleWrite("$SS_Indx_MTime: " & $SS_Indx_MTime & @CRLF)
		ConsoleWrite("$SS_Indx_RTime: " & $SS_Indx_RTime & @CRLF)
		ConsoleWrite("$NameTest: " & $NameTest & @CRLF)
		#ce
		If $LocalOffset >= StringLen($InputData) Then ExitLoop

		$OffsetToFileName_tmp = $OffsetToFileName
		If Mod($OffsetToFileName_tmp,8) Then
			While 1
				$OffsetToFileName_tmp+=1
				If Mod($OffsetToFileName_tmp,8) = 0 Then ExitLoop
			WEnd
		EndIf

		If $FileNameHealthy And $SS_Indx_NameLength > 0 And $SS_Indx_MTime<>$TimestampErrorVal And $SS_Indx_RTime<>$TimestampErrorVal And $SS_Indx_NameSpace <> "Unknown" And $SS_Indx_ReparseTag <> "UNKNOWN" And $SS_Indx_AllocSize >= $SS_Indx_RealSize And Mod($SS_Indx_AllocSize,8)=0 Then
			$SuccessCounter+=1
			If ($SS_MFTReferenceSeqNo = 0) Or ($SS_MFTReference=0 And $SS_Indx_FileName <> "$MFT") Then $TextInformation &= ";Invalid MftRef and SeqNo"
			If $SS_MFTReferenceOfParentSeqNo = 0 Then $TextInformation &= ";Invalid Parent MftRef and MftRefSeqNo"
			If $SS_Indx_CTime=$TimestampErrorVal Then $TextInformation &= ";Invalid CTime"
			If $SS_Indx_ATime=$TimestampErrorVal Then $TextInformation &= ";Invalid ATime"

			FileWriteLine($I30EntriesCsv, $SS_RecordOffset & $de & $HDR_MFTREcordNumber & $de & $SS_Indx_FileName & $de & $SS_MFTReference & $de & $SS_MFTReferenceSeqNo & $de & $SS_IndexFlags & $de & $SS_MFTReferenceOfParent & $de & $SS_MFTReferenceOfParentSeqNo & $de & $SS_Indx_CTime & $de & $SS_Indx_ATime & $de & $SS_Indx_MTime & $de & $SS_Indx_RTime & $de & $SS_Indx_AllocSize & $de & $SS_Indx_RealSize & $de & $SS_Indx_File_Flags & $de & $SS_Indx_ReparseTag & $de & $SS_Indx_NameSpace & $de & $TextInformation & @crlf)
			If $SS_IndexEntryLength = 0 Then $SS_IndexEntryLength = (32+26+($SS_Indx_NameLength*2))
			$LocalOffset += $SS_IndexEntryLength*2
			ContinueLoop
		Else
			$LocalOffset += 2
			;Check if there's any point in parsing the remaining bytes
			If Mod($Counter,16) = 0 Then
				If Not StringRegExp(StringMid($InputData,$LocalOffset),$RegExPattern) Then Return $SuccessCounter
			EndIf
		EndIf
	WEnd
	Return $SuccessCounter
EndFunc

Func _GetReparseType($ReparseType)
	;winnt.h
	;ntifs.h
	Select
		Case $ReparseType = '0x00000000'
			Return 'RESERVED_ZERO'
		Case $ReparseType = '0x00000001'
			Return 'RESERVED_ONE'
		Case $ReparseType = '0x00000002'
			Return 'RESERVED_TWO'
		Case $ReparseType = '0x80000005'
			Return 'DRIVER_EXTENDER'
		Case $ReparseType = '0x80000006'
			Return 'HSM2'
		Case $ReparseType = '0x80000007'
			Return 'SIS'
		Case $ReparseType = '0x80000008'
			Return 'WIM'
		Case $ReparseType = '0x80000009'
			Return 'CSV'
		Case $ReparseType = '0x8000000A'
			Return 'DFS'
		Case $ReparseType = '0x8000000B'
			Return 'FILTER_MANAGER'
		Case $ReparseType = '0x80000012'
			Return 'DFSR'
		Case $ReparseType = '0x80000013'
			Return 'DEDUP'
		Case $ReparseType = '0x80000014'
			Return 'NFS'
		Case $ReparseType = '0x80000015'
			Return 'FILE_PLACEHOLDER'
		Case $ReparseType = '0x80000017'
			Return 'WOF'
		Case $ReparseType = '0x80000018'
			Return 'WCI'
		Case $ReparseType = '0x80000019'
			Return 'GLOBAL_REPARSE'
		Case $ReparseType = '0x8000001B'
			Return 'APPEXECLINK'
		Case $ReparseType = '0x8000001E'
			Return 'HFS'
		Case $ReparseType = '0x80000020'
			Return 'UNHANDLED'
		Case $ReparseType = '0x80000021'
			Return 'ONEDRIVE'
		Case $ReparseType = '0x80000023'
			Return 'AF_UNIX'
		Case $ReparseType = '0x9000001C'
			Return 'PROJFS'
		Case $ReparseType = '0x9000001A'
			Return 'CLOUD'
		Case $ReparseType = '0x90001018'
			Return 'WCI_1'
		Case $ReparseType = '0x9000101A'
			Return 'CLOUD_1'
		Case $ReparseType = '0x9000201A'
			Return 'CLOUD_2'
		Case $ReparseType = '0x9000301A'
			Return 'CLOUD_3'
		Case $ReparseType = '0x9000401A'
			Return 'CLOUD_4'
		Case $ReparseType = '0x9000501A'
			Return 'CLOUD_5'
		Case $ReparseType = '0x9000601A'
			Return 'CLOUD_6'
		Case $ReparseType = '0x9000701A'
			Return 'CLOUD_7'
		Case $ReparseType = '0x9000801A'
			Return 'CLOUD_8'
		Case $ReparseType = '0x9000901A'
			Return 'CLOUD_9'
		Case $ReparseType = '0x9000A01A'
			Return 'CLOUD_A'
		Case $ReparseType = '0x9000B01A'
			Return 'CLOUD_B'
		Case $ReparseType = '0x9000C01A'
			Return 'CLOUD_C'
		Case $ReparseType = '0x9000D01A'
			Return 'CLOUD_D'
		Case $ReparseType = '0x9000E01A'
			Return 'CLOUD_E'
		Case $ReparseType = '0x9000F01A'
			Return 'CLOUD_F'
		Case $ReparseType = '0x9000401A'
			Return 'CLOUD_MASK'
		Case $ReparseType = '0x0000F000'
			Return 'GVFS'
		Case $ReparseType = '0xA0000003'
			Return 'MOUNT_POINT'
		Case $ReparseType = '0xA000000C'
			Return 'SYMLINK'
		Case $ReparseType = '0xA0000010'
			Return 'IIS_CACHE'
		Case $ReparseType = '0xA0000019'
			Return 'GLOBAL_REPARSE'
		Case $ReparseType = '0xA000001D'
			Return 'LX_SYMLINK'
		Case $ReparseType = '0xA000001F'
			Return 'WCI_TOMBSTONE'
		Case $ReparseType = '0xA0000022'
			Return 'GVFS_TOMBSTONE'
		Case $ReparseType = '0xA0000027'
			Return 'WCI_LINK'
		Case $ReparseType = '0xA0001027'
			Return 'WCI_LINK_1'
		Case $ReparseType = '0xA0000028'
			Return 'DATALESS_CIM'
		Case $ReparseType = '0xC0000004'
			Return 'HSM'
		Case $ReparseType = '0xC0000014'
			Return 'APPXSTRM'
		Case Else
			Return 'UNKNOWN(' & $ReparseType & ')'
	EndSelect
EndFunc

Func _ValidateCompleteName($InputString)
	Local $CarvedFileName=""
;	ConsoleWrite("$InputString: " & $InputString & @CRLF)
	$StringLength = StringLen($InputString)
	For $i = 1 To $StringLength Step 4
		;Skip first 4 characters as they are already tested
		If $i < 17 Then ContinueLoop
		$TestChunkHex = StringMid($InputString,$i,4)
;		ConsoleWrite("$TestChunkHex: " & $TestChunkHex & @CRLF)
		$TestChunk = Dec(_SwapEndian($TestChunkHex),2)
		If ($TestChunk >= 32 And $TestChunk < 127) And ($TestChunk <> 47 And $TestChunk <> 92 And $TestChunk <> 58 And $TestChunk <> 42 And $TestChunk <> 63 And $TestChunk <> 34 And $TestChunk <> 60 And $TestChunk <> 62) Then
			ContinueLoop
		Else
			ExitLoop
		EndIf
	Next
	$CarvedFileName = BinaryToString("0x"&StringMid($InputString,1,$i-1),2)
;	ConsoleWrite("$CarvedFileName: " & $CarvedFileName & @CRLF)
	Return $CarvedFileName
EndFunc

Func _ValidateMinimumFileName($InputString)
;	ConsoleWrite("$InputString: " & $InputString & @CRLF)
	;Test A-Z
	$TestChunk = StringMid($InputString,1,4)
	$TestChunk = Dec(_SwapEndian($TestChunk),2)
	If Not ($TestChunk >= 65 And $TestChunk <= 90) Then Return 0
	;Test :
	$TestChunk = StringMid($InputString,5,4)
	$TestChunk = Dec(_SwapEndian($TestChunk),2)
	If Not ($TestChunk = 58) Then Return 0
	;Test \
	$TestChunk = StringMid($InputString,9,4)
	$TestChunk = Dec(_SwapEndian($TestChunk),2)
	If Not ($TestChunk = 92) Then Return 0
	;Test first character in filename
	$TestChunk = StringMid($InputString,13,4)
	$TestChunk = Dec(_SwapEndian($TestChunk),2)
	If Not ($TestChunk >= 32 And $TestChunk < 127) Then Return 0
	If Not ($TestChunk <> 47 And $TestChunk <> 92 And $TestChunk <> 58 And $TestChunk <> 42 And $TestChunk <> 63 And $TestChunk <> 34 And $TestChunk <> 60 And $TestChunk <> 62) Then  Return 0
	Return 1
EndFunc

Func _ValidateAnsiName($InputString)
;ConsoleWrite("$InputString: " & $InputString & @CRLF)
	$StringLength = StringLen($InputString)
	For $i = 1 To $StringLength Step 4
		$TestChunk = StringMid($InputString,$i,4)
		$TestChunk = Dec(_SwapEndian($TestChunk),2)
		If ($TestChunk >= 32 And $TestChunk < 127) Then
			ContinueLoop
		Else
			Return 0
		EndIf
	Next
	Return 1
EndFunc

Func _ValidateWindowsFileName($InputString)
	$StringLength = StringLen($InputString)
	For $i = 1 To $StringLength Step 4
		$TestChunk = StringMid($InputString,$i,4)
		$TestChunk = Dec(_SwapEndian($TestChunk),2)
		If ($TestChunk <> 47 And $TestChunk <> 92 And $TestChunk <> 58 And $TestChunk <> 42 And $TestChunk <> 63 And $TestChunk <> 34 And $TestChunk <> 60 And $TestChunk <> 62) Then
			ContinueLoop
		Else
			Return 0
		EndIf
	Next
	Return 1
EndFunc

Func _Get_StandardInformation($MFTEntry, $SI_Offset)
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
	$SI_FilePermission = _File_Attributes("0x" & $SI_FilePermission)
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

Func _Get_FileName($MFTEntry, $FN_Offset, $FN_Number)
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
		$FN_Flags = _File_Attributes("0x" & $FN_Flags)
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
		$FN_Flags_2 = _File_Attributes("0x" & $FN_Flags_2)
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
		$FN_Flags_3 = _File_Attributes("0x" & $FN_Flags_3)
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
	;FILE_OBJECTID_BUFFER structure
	;https://msdn.microsoft.com/en-us/library/aa364393(v=vs.85).aspx
	Local $GUID_ObjectID_Version,$GUID_ObjectID_Timestamp,$GUID_ObjectID_TimestampDec,$GUID_ObjectID_ClockSeq,$GUID_ObjectID_Node
	Local $GUID_BirthVolumeID_Version,$GUID_BirthVolumeID_Timestamp,$GUID_BirthVolumeID_TimestampDec,$GUID_BirthVolumeID_ClockSeq,$GUID_BirthVolumeID_Node
	Local $GUID_BirthObjectID_Version,$GUID_BirthObjectID_Timestamp,$GUID_BirthObjectID_TimestampDec,$GUID_BirthObjectID_ClockSeq,$GUID_BirthObjectID_Node
	Local $GUID_DomainID_Version,$GUID_DomainID_Timestamp,$GUID_DomainID_TimestampDec,$GUID_DomainID_ClockSeq,$GUID_DomainID_Node
	;ObjectId
	$GUID_ObjectID = StringMid($MFTEntry,$OBJECTID_Offset+48,32)
	;Decode guid
	$GUID_ObjectID_Version = Dec(StringMid($GUID_ObjectID,15,1))
	$GUID_ObjectID_Timestamp = StringMid($GUID_ObjectID,1,14) & "0" & StringMid($GUID_ObjectID,16,1)
	$GUID_ObjectID_TimestampDec = Dec(_SwapEndian($GUID_ObjectID_Timestamp),2)
	$GUID_ObjectID_Timestamp = _DecodeTimestampFromGuid($GUID_ObjectID_Timestamp)
	$GUID_ObjectID_ClockSeq = StringMid($GUID_ObjectID,17,4)
	$GUID_ObjectID_ClockSeq = Dec($GUID_ObjectID_ClockSeq)
	$GUID_ObjectID_Node = StringMid($GUID_ObjectID,21,12)
	$GUID_ObjectID_Node = _DecodeMacFromGuid($GUID_ObjectID_Node)
	$GUID_ObjectID = _HexToGuidStr($GUID_ObjectID,1)
	Select
		Case $OBJECTID_Size - 24 = 16
			$GUID_BirthVolumeID = "NOT PRESENT"
			$GUID_BirthObjectID = "NOT PRESENT"
			$GUID_DomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 32
			;BirthVolumeId
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			;Decode guid
			$GUID_BirthVolumeID_Version = Dec(StringMid($GUID_BirthVolumeID,15,1))
			$GUID_BirthVolumeID_Timestamp = StringMid($GUID_BirthVolumeID,1,14) & "0" & StringMid($GUID_BirthVolumeID,16,1)
			$GUID_BirthVolumeID_TimestampDec = Dec(_SwapEndian($GUID_BirthVolumeID_Timestamp),2)
			$GUID_BirthVolumeID_Timestamp = _DecodeTimestampFromGuid($GUID_BirthVolumeID_Timestamp)
			$GUID_BirthVolumeID_ClockSeq = StringMid($GUID_BirthVolumeID,17,4)
			$GUID_BirthVolumeID_ClockSeq = Dec($GUID_BirthVolumeID_ClockSeq)
			$GUID_BirthVolumeID_Node = StringMid($GUID_BirthVolumeID,21,12)
			$GUID_BirthVolumeID_Node = _DecodeMacFromGuid($GUID_BirthVolumeID_Node)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			$GUID_BirthObjectID = "NOT PRESENT"
			$GUID_DomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 48
			;BirthVolumeId
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			;Decode guid
			$GUID_BirthVolumeID_Version = Dec(StringMid($GUID_BirthVolumeID,15,1))
			$GUID_BirthVolumeID_Timestamp = StringMid($GUID_BirthVolumeID,1,14) & "0" & StringMid($GUID_BirthVolumeID,16,1)
			$GUID_BirthVolumeID_TimestampDec = Dec(_SwapEndian($GUID_BirthVolumeID_Timestamp),2)
			$GUID_BirthVolumeID_Timestamp = _DecodeTimestampFromGuid($GUID_BirthVolumeID_Timestamp)
			$GUID_BirthVolumeID_ClockSeq = StringMid($GUID_BirthVolumeID,17,4)
			$GUID_BirthVolumeID_ClockSeq = Dec($GUID_BirthVolumeID_ClockSeq)
			$GUID_BirthVolumeID_Node = StringMid($GUID_BirthVolumeID,21,12)
			$GUID_BirthVolumeID_Node = _DecodeMacFromGuid($GUID_BirthVolumeID_Node)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			;BirthObjectId
			$GUID_BirthObjectID = StringMid($MFTEntry,$OBJECTID_Offset+112,32)
			;Decode guid
			$GUID_BirthObjectID_Version = Dec(StringMid($GUID_BirthObjectID,15,1))
			$GUID_BirthObjectID_Timestamp = StringMid($GUID_BirthObjectID,1,14) & "0" & StringMid($GUID_BirthObjectID,16,1)
			$GUID_BirthObjectID_TimestampDec = Dec(_SwapEndian($GUID_BirthObjectID_Timestamp),2)
			$GUID_BirthObjectID_Timestamp = _DecodeTimestampFromGuid($GUID_BirthObjectID_Timestamp)
			$GUID_BirthObjectID_ClockSeq = StringMid($GUID_BirthObjectID,17,4)
			$GUID_BirthObjectID_ClockSeq = Dec($GUID_BirthObjectID_ClockSeq)
			$GUID_BirthObjectID_Node = StringMid($GUID_BirthObjectID,21,12)
			$GUID_BirthObjectID_Node = _DecodeMacFromGuid($GUID_BirthObjectID_Node)
			$GUID_BirthObjectID = _HexToGuidStr($GUID_BirthObjectID,1)
			$GUID_DomainID = "NOT PRESENT"
		Case $OBJECTID_Size - 24 = 64
			;BirthVolumeId
			$GUID_BirthVolumeID = StringMid($MFTEntry,$OBJECTID_Offset+80,32)
			;Decode guid
			$GUID_BirthVolumeID_Version = Dec(StringMid($GUID_BirthVolumeID,15,1))
			$GUID_BirthVolumeID_Timestamp = StringMid($GUID_BirthVolumeID,1,14) & "0" & StringMid($GUID_BirthVolumeID,16,1)
			$GUID_BirthVolumeID_TimestampDec = Dec(_SwapEndian($GUID_BirthVolumeID_Timestamp),2)
			$GUID_BirthVolumeID_Timestamp = _DecodeTimestampFromGuid($GUID_BirthVolumeID_Timestamp)
			$GUID_BirthVolumeID_ClockSeq = StringMid($GUID_BirthVolumeID,17,4)
			$GUID_BirthVolumeID_ClockSeq = Dec($GUID_BirthVolumeID_ClockSeq)
			$GUID_BirthVolumeID_Node = StringMid($GUID_BirthVolumeID,21,12)
			$GUID_BirthVolumeID_Node = _DecodeMacFromGuid($GUID_BirthVolumeID_Node)
			$GUID_BirthVolumeID = _HexToGuidStr($GUID_BirthVolumeID,1)
			;BirthObjectId
			$GUID_BirthObjectID = StringMid($MFTEntry,$OBJECTID_Offset+112,32)
			;Decode guid
			$GUID_BirthObjectID_Version = Dec(StringMid($GUID_BirthObjectID,15,1))
			$GUID_BirthObjectID_Timestamp = StringMid($GUID_BirthObjectID,1,14) & "0" & StringMid($GUID_BirthObjectID,16,1)
			$GUID_BirthObjectID_TimestampDec = Dec(_SwapEndian($GUID_BirthObjectID_Timestamp),2)
			$GUID_BirthObjectID_Timestamp = _DecodeTimestampFromGuid($GUID_BirthObjectID_Timestamp)
			$GUID_BirthObjectID_ClockSeq = StringMid($GUID_BirthObjectID,17,4)
			$GUID_BirthObjectID_ClockSeq = Dec($GUID_BirthObjectID_ClockSeq)
			$GUID_BirthObjectID_Node = StringMid($GUID_BirthObjectID,21,12)
			$GUID_BirthObjectID_Node = _DecodeMacFromGuid($GUID_BirthObjectID_Node)
			$GUID_BirthObjectID = _HexToGuidStr($GUID_BirthObjectID,1)
			;DomainId
			$GUID_DomainID = StringMid($MFTEntry,$OBJECTID_Offset+144,32)
			;Decode guid
			$GUID_DomainID_Version = Dec(StringMid($GUID_DomainID,15,1))
			$GUID_DomainID_Timestamp = StringMid($GUID_DomainID,1,14) & "0" & StringMid($GUID_DomainID,16,1)
			$GUID_DomainID_TimestampDec = Dec(_SwapEndian($GUID_DomainID_Timestamp),2)
			$GUID_DomainID_Timestamp = _DecodeTimestampFromGuid($GUID_DomainID_Timestamp)
			$GUID_DomainID_ClockSeq = StringMid($GUID_DomainID,17,4)
			$GUID_DomainID_ClockSeq = Dec($GUID_DomainID_ClockSeq)
			$GUID_DomainID_Node = StringMid($GUID_DomainID,21,12)
			$GUID_DomainID_Node = _DecodeMacFromGuid($GUID_DomainID_Node)
			$GUID_DomainID = _HexToGuidStr($GUID_DomainID,1)
		Case Else
			;ExtendedInfo instead of DomainId?
			_DebugOut("Error: The $OBJECT_ID size (" & $OBJECTID_Size - 24 & ") was unexpected.", "0x" & StringMid($MFTEntry,$OBJECTID_Offset))
	EndSelect
	;Write the decoded guid info to a separate file
	FileWriteLine($EntriesObjectIdCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $GUID_ObjectID & $de & $GUID_ObjectID_Version & $de & $GUID_ObjectID_Timestamp & $de & $GUID_ObjectID_TimestampDec & $de & $GUID_ObjectID_ClockSeq & $de & $GUID_ObjectID_Node & $de & $GUID_BirthVolumeID & $de & $GUID_BirthVolumeID_Version & $de & $GUID_BirthVolumeID_Timestamp & $de & $GUID_BirthVolumeID_TimestampDec & $de & $GUID_BirthVolumeID_ClockSeq & $de & $GUID_BirthVolumeID_Node & $de & $GUID_BirthObjectID & $de & $GUID_BirthObjectID_Version & $de & $GUID_BirthObjectID_Timestamp & $de & $GUID_BirthObjectID_TimestampDec & $de & $GUID_BirthObjectID_ClockSeq & $de & $GUID_BirthObjectID_Node & $de & $GUID_DomainID & $de & $GUID_DomainID_Version & $de & $GUID_DomainID_Timestamp & $de & $GUID_DomainID_TimestampDec & $de & $GUID_DomainID_ClockSeq & $de & $GUID_DomainID_Node & @crlf)
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

Func _Get_VolumeInformation($MFTEntry, $VOLUME_INFO_Offset)
	$VOL_INFO_NTFS_VERSION = Dec(StringMid($MFTEntry, $VOLUME_INFO_Offset + 64, 2)) & "," & Dec(StringMid($MFTEntry, $VOLUME_INFO_Offset + 66, 2))
	$VOL_INFO_FLAGS = StringMid($MFTEntry, $VOLUME_INFO_Offset + 68, 4)
	$VOL_INFO_FLAGS = _SwapEndian($VOL_INFO_FLAGS)
	$VOL_INFO_FLAGS = _VolInfoFlag("0x" & $VOL_INFO_FLAGS)
	Return
EndFunc   ;==>_Get_VolumeInformation

Func _Get_Data($MFTEntry, $DT_Offset, $DT_Size, $DT_Number)
	Local $Offset
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
			If $DT_LastVCN > $DT_StartVCN Then
				$DT_VCNs = $DT_LastVCN - $DT_StartVCN
			Else
				$DT_VCNs = 0
			EndIf
			$Offset = Dec(_SwapEndian(StringMid($MFTEntry,$DT_Offset + 64,4)))
			;ConsoleWrite("$Offset: 0x" & Hex($Offset, 8) & @CRLF)
			$DT_DataRun = StringMid($MFTEntry,$DT_Offset + ($Offset*2),($DT_Size-$Offset)*2)
			;ConsoleWrite("$DT_DataRun: " & $DT_DataRun & @CRLF)
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
			If $DT_LastVCN_2 > $DT_StartVCN_2 Then
				$DT_VCNs_2 = $DT_LastVCN_2 - $DT_StartVCN_2
			Else
				$DT_VCNs_2 = 0
			EndIf
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
			If $DT_LastVCN_3 > $DT_StartVCN_3 Then
				$DT_VCNs_3 = $DT_LastVCN_3 - $DT_StartVCN_3
			Else
				$DT_VCNs_3 = 0
			EndIf
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

Func _WriteCSVHeaderAdditionalData()
	$CsvHeader = "Offset"&$de&"MftRef"&$de&"MftSeqNo"&$de&"data_number"&$de&"Name"&$de&"Flags"&$de&"NonResidentFlag"&$de&"LengthOfAttribute"&$de&"IndexedFlag"&$de&"CompressionUnitSize"&$de&"AllocatedSize"&$de&"RealSize"&$de&"InitializedStreamSize"&$de&"StartVCN"&$de&"LastVCN"&$de&"VCNs"&$de&"DataRun"
	FileWriteLine($AdditionalDataCsvFile, $CsvHeader & @CRLF)
EndFunc

Func _Get_AdditionalData($MFTEntry, $lDT_Offset, $lDT_Size, $lDT_Number)

	; for $DATA beyond x4 which is not covered by the regular csv logging _Get_Data()
	; dump in separate output
	Local $lOffset, $lDT_NonResidentFlag, $lDT_NameLength, $lDT_NameRelativeOffset, $lDT_Flags, $lDT_Name, $lDT_AllocSize, $lDT_RealSize, $lDT_InitStreamSize
	Local $lDT_StartVCN, $lDT_LastVCN, $lDT_VCNs, $lDT_DataRun, $lDT_LengthOfAttribute, $lDT_IndexedFlag, $lDT_ComprUnitSize

	$lDT_NonResidentFlag = StringMid($MFTEntry, $lDT_Offset + 16, 2)
	$lDT_NameLength = Dec(StringMid($MFTEntry, $lDT_Offset + 18, 2))
	$lDT_NameRelativeOffset = StringMid($MFTEntry, $lDT_Offset + 20, 4)
	$lDT_NameRelativeOffset = Dec(_SwapEndian($lDT_NameRelativeOffset), 2)
	$lDT_Flags = StringMid($MFTEntry, $lDT_Offset + 24, 4)
	$lDT_Flags = _SwapEndian($lDT_Flags)
	$lDT_Flags = _AttribHeaderFlags("0x" & $lDT_Flags)
	If $lDT_NameLength > 0 Then
		;$lDT_NameSpace = $lDT_NameLength - 1
		$lDT_Name = StringMid($MFTEntry, $lDT_Offset + ($lDT_NameRelativeOffset * 2), $lDT_NameLength * 4)
		$lDT_Name = BinaryToString("0x"&$lDT_Name, 2)
	EndIf
	If $lDT_NonResidentFlag = '01' Then
		$lDT_StartVCN = StringMid($MFTEntry, $lDT_Offset + 32, 16)
		$lDT_StartVCN = Dec(_SwapEndian($lDT_StartVCN), 2)
		$lDT_LastVCN = StringMid($MFTEntry, $lDT_Offset + 48, 16)
		$lDT_LastVCN = Dec(_SwapEndian($lDT_LastVCN), 2)
		If $lDT_LastVCN > $lDT_StartVCN Then
			$lDT_VCNs = $lDT_LastVCN - $lDT_StartVCN
		Else
			$lDT_VCNs = 0
		EndIf
		$lOffset = Dec(_SwapEndian(StringMid($MFTEntry,$lDT_Offset + 64, 4)))
		;ConsoleWrite("$Offset: 0x" & Hex($Offset, 8) & @CRLF)
		$lDT_DataRun = StringMid($MFTEntry,$lDT_Offset + ($lOffset * 2), ($lDT_Size - $lOffset) * 2)
		;ConsoleWrite("$lDT_DataRun: " & $lDT_DataRun & @CRLF)
		$lDT_ComprUnitSize = StringMid($MFTEntry, $lDT_Offset + 68, 4)
		$lDT_ComprUnitSize = Dec(_SwapEndian($lDT_ComprUnitSize), 2)
		$lDT_AllocSize = StringMid($MFTEntry, $lDT_Offset + 80, 16)
		$lDT_AllocSize = Dec(_SwapEndian($lDT_AllocSize), 2)
		$lDT_RealSize = StringMid($MFTEntry, $lDT_Offset + 96, 16)
		$lDT_RealSize = Dec(_SwapEndian($lDT_RealSize), 2)
		;$FileSizeBytes = $lDT_RealSize
		$lDT_InitStreamSize = StringMid($MFTEntry, $lDT_Offset + 112, 16)
		$lDT_InitStreamSize = Dec(_SwapEndian($lDT_InitStreamSize), 2)
	ElseIf $lDT_NonResidentFlag = '00' Then
		$lDT_LengthOfAttribute = StringMid($MFTEntry, $lDT_Offset + 32, 8)
		$lDT_LengthOfAttribute = Dec(_SwapEndian($lDT_LengthOfAttribute), 2)
		;$FileSizeBytes = $lDT_LengthOfAttribute
		$lDT_OffsetToAttribute = StringMid($MFTEntry, $lDT_Offset + 40, 4)
		$lDT_OffsetToAttribute = Dec(_SwapEndian($lDT_OffsetToAttribute), 2)
		$lDT_IndexedFlag = Dec(StringMid($MFTEntry, $lDT_Offset + 44, 2))
	EndIf
	;$RecordOffset+$lDT_Offset
	FileWriteLine($AdditionalDataCsvFile, $RecordOffset & $de & $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $lDT_Number & $de & $lDT_Name & $de & $lDT_Flags & $de & $lDT_NonResidentFlag & $de & $lDT_LengthOfAttribute & $de &  _
		$lDT_IndexedFlag & $de & $lDT_ComprUnitSize & $de & $lDT_AllocSize & $de & $lDT_RealSize & $de & $lDT_InitStreamSize & $de & $lDT_StartVCN & $de & $lDT_LastVCN & $de & $lDT_VCNs & $de & $lDT_DataRun & @crlf)
EndFunc

Func _Get_IndexAllocation()
;	ConsoleWrite("Get_IndexAllocation Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_IndexAllocation

Func _Get_Bitmap()
;	ConsoleWrite("Get_Bitmap Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_Bitmap

Func _Get_EaInformation()
;	ConsoleWrite("Get_EaInformation Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_EaInformation

Func _Get_PropertySet()
;	ConsoleWrite("Get_PropertySet Function not implemented yet." & @CRLF)
	Return
EndFunc   ;==>_Get_PropertySet

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
	$DT_DataRun = ""
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
	$GUID_DomainID = ""
	$VOLUME_NAME_NAME = ""
	$VOL_INFO_NTFS_VERSION = ""
	$VOL_INFO_FLAGS = ""
	$DT_Number = ""
	$ADS = ""
	$FileSizeBytes = ""
	$SI_CTime_tmp = ""
	$FN_CTime_tmp = ""
	#cs
	$SI_ATime_tmp = ""
	$SI_MTime_tmp = ""
	$SI_RTime_tmp = ""
	$FN_ATime_tmp = ""
	$FN_MTime_tmp = ""
	$FN_RTime_tmp = ""
	$FN_CTime_2_tmp = ""
	$FN_ATime_2_tmp = ""
	$FN_MTime_2_tmp = ""
	$FN_RTime_2_tmp = ""
	#ce
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

Func _Test_SI2FN_CTime()
	If $SI_CTime_tmp < $FN_CTime_tmp Then
		$CTimeTest = 1
	Else
		$CTimeTest = 0
	EndIf
	Return $CTimeTest
EndFunc   ;==>_Test_SI2FN_CTime

Func _File_Attributes($FAInput)
	Local $FAOutput = ""
	If BitAND($FAInput, 0x0001) Then $FAOutput &= 'read_only+'
	If BitAND($FAInput, 0x0002) Then $FAOutput &= 'hidden+'
	If BitAND($FAInput, 0x0004) Then $FAOutput &= 'system+'
	If BitAND($FAInput, 0x0010) Then $FAOutput &= 'directory1+'
	If BitAND($FAInput, 0x0020) Then $FAOutput &= 'archive+'
	If BitAND($FAInput, 0x0040) Then $FAOutput &= 'device+'
	If BitAND($FAInput, 0x0080) Then $FAOutput &= 'normal+'
	If BitAND($FAInput, 0x0100) Then $FAOutput &= 'temporary+'
	If BitAND($FAInput, 0x0200) Then $FAOutput &= 'sparse_file+'
	If BitAND($FAInput, 0x0400) Then $FAOutput &= 'reparse_point+'
	If BitAND($FAInput, 0x0800) Then $FAOutput &= 'compressed+'
	If BitAND($FAInput, 0x1000) Then $FAOutput &= 'offline+'
	If BitAND($FAInput, 0x2000) Then $FAOutput &= 'not_content_indexed+'
	If BitAND($FAInput, 0x4000) Then $FAOutput &= 'encrypted+'
	If BitAND($FAInput, 0x8000) Then $FAOutput &= 'integrity_stream+'
	If BitAND($FAInput, 0x10000) Then $FAOutput &= 'virtual+'
	If BitAND($FAInput, 0x20000) Then $FAOutput &= 'no_scrub_data+'
	If BitAND($FAInput, 0x40000) Then $FAOutput &= 'ea+'
	If BitAND($FAInput, 0x80000) Then $FAOutput &= 'pinned+'
	If BitAND($FAInput, 0x100000) Then $FAOutput &= 'unpinned+'
	If BitAND($FAInput, 0x400000) Then $FAOutput &= 'recall_on_data_access+'
	If BitAND($FAInput, 0x20000000) Then $FAOutput &= 'index_view+' ; strictly_sequencial?
	$FAOutput = StringTrimRight($FAOutput, 1)
	Return $FAOutput
EndFunc

Func _AttribHeaderFlags($AHinput)
	Local $AHoutput = ""
	If BitAND($AHinput, 0x0001) Then $AHoutput &= 'COMPRESSED+'
	If BitAND($AHinput, 0x4000) Then $AHoutput &= 'ENCRYPTED+'
	If BitAND($AHinput, 0x8000) Then $AHoutput &= 'SPARSE+'
	$AHoutput = StringTrimRight($AHoutput, 1)
	Return $AHoutput
EndFunc   ;==>_AttribHeaderFlags

Func _VolInfoFlag($VIFinput)
	Local $VIFoutput = ""
	If BitAND($VIFinput, 0x0001) Then $VIFoutput &= 'DIRTY+'
	If BitAND($VIFinput, 0x0002) Then $VIFoutput &= 'RESIZE_LOGFILE+'
	If BitAND($VIFinput, 0x0004) Then $VIFoutput &= 'UPGRADE_ON_MOUNT+'
	If BitAND($VIFinput, 0x0008) Then $VIFoutput &= 'MOUNTED_ON_NT4+'
	If BitAND($VIFinput, 0x0010) Then $VIFoutput &= 'DELETE_USN_UNDERWAY+'
	If BitAND($VIFinput, 0x0020) Then $VIFoutput &= 'REPAIR_OBJECT_ID+'
	If BitAND($VIFinput, 0x4000) Then $VIFoutput &= 'CHKDSK_APPLIED_FIXES+'
	If BitAND($VIFinput, 0x8000) Then $VIFoutput &= 'MODIFIED_BY_CHKDSK+'
	If StringLen($VIFoutput) = 0 Then Return
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
			$FN_MTime_2 & $de & $FN_RTime_2 & $de & $FN_AllocSize_2 & $de & $FN_RealSize_2 & $de & $FN_EaSize_2 & $de & $FN_Flags_2 & $de & $FN_NameLen_2 & $de & $FN_NameType_2 & $de & $FN_Name_2 & $de & $GUID_ObjectID & $de & $GUID_BirthVolumeID & $de & $GUID_BirthObjectID & $de & $GUID_DomainID & $de & $VOLUME_NAME_NAME & $de & $VOL_INFO_NTFS_VERSION & $de & $VOL_INFO_FLAGS & $de & $FN_CTime_3 & $de & $FN_ATime_3 & $de & $FN_MTime_3 & $de & $FN_RTime_3 & $de & $FN_AllocSize_3 & $de & $FN_RealSize_3 & $de & $FN_EaSize_3 & $de & $FN_Flags_3 & $de & $FN_NameLen_3 & $de & $FN_NameType_3 & $de & $FN_Name_3 & $de & _
			$DT_Name_2 & $de & $DT_NonResidentFlag_2 & $de & $DT_Flags_2 & $de & $DT_LengthOfAttribute_2 & $de & $DT_IndexedFlag_2 & $de & $DT_StartVCN_2 & $de & $DT_LastVCN_2 & $de & _
			$DT_VCNs_2 & $de & $DT_ComprUnitSize_2 & $de & $DT_AllocSize_2 & $de & $DT_RealSize_2 & $de & $DT_InitStreamSize_2 & $de & $DT_Name_3 & $de & $DT_NonResidentFlag_3 & $de & $DT_Flags_3 & $de & $DT_LengthOfAttribute_3 & $de & $DT_IndexedFlag_3 & $de & $DT_StartVCN_3 & $de & $DT_LastVCN_3 & $de & $DT_VCNs_3 & $de & $DT_ComprUnitSize_3 & $de & $DT_AllocSize_3 & $de & _
			$DT_RealSize_3 & $de & $DT_InitStreamSize_3 & $de & $SI_ON & $de & $AL_ON & $de & $FN_ON & $de & $OI_ON & $de & $SD_ON & $de & $VN_ON & $de & $VI_ON & $de & $DT_ON & $de & $IR_ON & $de & $IA_ON & $de & $BITMAP_ON & $de & $RP_ON & $de & $EAI_ON & $de & $EA_ON & $de & $PS_ON & $de & $LUS_ON  & $de & $DT_DataRun & @CRLF)
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
		$FN_MTime_2&'"'&$de&'"'&$FN_RTime_2&'"'&$de&'"'&$FN_AllocSize_2&'"'&$de&'"'&$FN_RealSize_2&'"'&$de&'"'&$FN_EaSize_2&'"'&$de&'"'&$FN_Flags_2&'"'&$de&'"'&$FN_NameLen_2&'"'&$de&'"'&$FN_NameType_2&'"'&$de&'"'&$FN_Name_2&'"'&$de&'"'&$GUID_ObjectID&'"'&$de&'"'&$GUID_BirthVolumeID&'"'&$de&'"'&$GUID_BirthObjectID&'"'&$de&'"'&$GUID_DomainID&'"'&$de&'"'&$VOLUME_NAME_NAME&'"'&$de&'"'&$VOL_INFO_NTFS_VERSION&'"'&$de&'"'&$VOL_INFO_FLAGS&'"'&$de&'"'&$FN_CTime_3&'"'&$de&'"'&$FN_ATime_3&'"'&$de&'"'&$FN_MTime_3&'"'&$de&'"'&$FN_RTime_3&'"'&$de&'"'&$FN_AllocSize_3&'"'&$de&'"' & _
		$FN_RealSize_3&'"'&$de&'"'&$FN_EaSize_3&'"'&$de&'"'&$FN_Flags_3&'"'&$de&'"'&$FN_NameLen_3&'"'&$de&'"'&$FN_NameType_3&'"'&$de&'"'&$FN_Name_3&'"'&$de&'"'&$DT_Name_2&'"'&$de&'"'&$DT_NonResidentFlag_2&'"'&$de&'"'&$DT_Flags_2&'"'&$de&'"'&$DT_LengthOfAttribute_2&'"'&$de&'"'&$DT_IndexedFlag_2&'"'&$de&'"'&$DT_StartVCN_2&'"'&$de&'"'&$DT_LastVCN_2&'"'&$de&'"' & _
		$DT_VCNs_2&'"'&$de&'"'&$DT_ComprUnitSize_2&'"'&$de&'"'&$DT_AllocSize_2&'"'&$de&'"'&$DT_RealSize_2&'"'&$de&'"'&$DT_InitStreamSize_2&'"'&$de&'"'&$DT_Name_3&'"'&$de&'"'&$DT_NonResidentFlag_3&'"'&$de&'"'&$DT_Flags_3&'"'&$de&'"'&$DT_LengthOfAttribute_3&'"'&$de&'"'&$DT_IndexedFlag_3&'"'&$de&'"'&$DT_StartVCN_3&'"'&$de&'"'&$DT_LastVCN_3&'"'&$de&'"'&$DT_VCNs_3&'"'&$de&'"'&$DT_ComprUnitSize_3&'"'&$de&'"'&$DT_AllocSize_3&'"'&$de&'"' & _
		$DT_RealSize_3&'"'&$de&'"'&$DT_InitStreamSize_3&'"'&$de&'"'&$SI_ON&'"'&$de&'"'&$AL_ON&'"'&$de&'"'&$FN_ON&'"'&$de&'"'&$OI_ON&'"'&$de&'"'&$SD_ON&'"'&$de&'"'&$VN_ON&'"'&$de&'"'&$VI_ON&'"'&$de&'"'&$DT_ON&'"'&$de&'"'&$IR_ON&'"'&$de&'"'&$IA_ON&'"'&$de&'"'&$BITMAP_ON&'"'&$de&'"'&$RP_ON&'"'&$de&'"'&$EAI_ON&'"'&$de&'"'&$EA_ON&'"'&$de&'"'&$PS_ON&'"'&$de&'"'&$LUS_ON&'"'&$de&'"'&$DT_DataRun&'"'&@CRLF)
EndFunc


Func _WriteCSVHeader()
	Local $csv_header
	If $DoDefaultAll Then
		$csv_header = "RecordOffset"&$de&"Signature"&$de&"IntegrityCheck"&$de&"Style"&$de&"HEADER_MFTREcordNumber"&$de&"HEADER_SequenceNo"&$de&"Header_HardLinkCount"&$de&"FN_ParentReferenceNo"&$de&"FN_ParentSequenceNo"&$de&"FN_FileName"&$de&"FilePath"&$de&"HEADER_Flags"&$de&"RecordActive"&$de&"FileSizeBytes"&$de&"SI_FilePermission"&$de&"FN_Flags"&$de&"FN_NameType"&$de&"ADS"&$de&"SI_CTime"&$de&"SI_ATime"&$de&"SI_MTime"&$de&"SI_RTime"&$de&"MSecTest"&$de
		$csv_header &= "FN_CTime"&$de&"FN_ATime"&$de&"FN_MTime"&$de&"FN_RTime"&$de&"CTimeTest"&$de&"FN_AllocSize"&$de&"FN_RealSize"&$de&"FN_EaSize"&$de&"SI_USN"&$de&"DATA_Name"&$de&"DATA_Flags"&$de&"DATA_LengthOfAttribute"&$de&"DATA_IndexedFlag"&$de&"DATA_VCNs"&$de&"DATA_NonResidentFlag"&$de&"DATA_CompressionUnitSize"&$de&"HEADER_LSN"&$de&"HEADER_RecordRealSize"&$de
		$csv_header &= "HEADER_RecordAllocSize"&$de&"HEADER_BaseRecord"&$de&"HEADER_BaseRecSeqNo"&$de&"HEADER_NextAttribID"&$de&"DATA_AllocatedSize"&$de&"DATA_RealSize"&$de&"DATA_InitializedStreamSize"&$de&"SI_HEADER_Flags"&$de&"SI_MaxVersions"&$de&"SI_VersionNumber"&$de&"SI_ClassID"&$de&"SI_OwnerID"&$de&"SI_SecurityID"&$de&"SI_Quota"&$de&"FN_CTime_2"&$de&"FN_ATime_2"&$de&"FN_MTime_2"&$de
		$csv_header &= "FN_RTime_2"&$de&"FN_AllocSize_2"&$de&"FN_RealSize_2"&$de&"FN_EaSize_2"&$de&"FN_Flags_2"&$de&"FN_NameLength_2"&$de&"FN_NameType_2"&$de&"FN_FileName_2"&$de&"GUID_ObjectID"&$de&"GUID_BirthVolumeID"&$de&"GUID_BirthObjectID"&$de&"GUID_DomainID"&$de&"VOLUME_NAME_NAME"&$de&"VOL_INFO_NTFS_VERSION"&$de&"VOL_INFO_FLAGS"&$de&"FN_CTime_3"&$de&"FN_ATime_3"&$de&"FN_MTime_3"&$de&"FN_RTime_3"&$de&"FN_AllocSize_3"&$de&"FN_RealSize_3"&$de&"FN_EaSize_3"&$de&"FN_Flags_3"&$de&"FN_NameLength_3"&$de&"FN_NameType_3"&$de&"FN_FileName_3"&$de
		$csv_header &= "DATA_Name_2"&$de&"DATA_NonResidentFlag_2"&$de&"DATA_Flags_2"&$de&"DATA_LengthOfAttribute_2"&$de&"DATA_IndexedFlag_2"&$de&"DATA_StartVCN_2"&$de&"DATA_LastVCN_2"&$de
		$csv_header &= "DATA_VCNs_2"&$de&"DATA_CompressionUnitSize_2"&$de&"DATA_AllocatedSize_2"&$de&"DATA_RealSize_2"&$de&"DATA_InitializedStreamSize_2"&$de&"DATA_Name_3"&$de&"DATA_NonResidentFlag_3"&$de&"DATA_Flags_3"&$de&"DATA_LengthOfAttribute_3"&$de&"DATA_IndexedFlag_3"&$de&"DATA_StartVCN_3"&$de&"DATA_LastVCN_3"&$de&"DATA_VCNs_3"&$de
		$csv_header &= "DATA_CompressionUnitSize_3"&$de&"DATA_AllocatedSize_3"&$de&"DATA_RealSize_3"&$de&"DATA_InitializedStreamSize_3"&$de&"STANDARD_INFORMATION_ON"&$de&"ATTRIBUTE_LIST_ON"&$de&"FILE_NAME_ON"&$de&"OBJECT_ID_ON"&$de&"SECURITY_DESCRIPTOR_ON"&$de&"VOLUME_NAME_ON"&$de&"VOLUME_INFORMATION_ON"&$de&"DATA_ON"&$de&"INDEX_ROOT_ON"&$de&"INDEX_ALLOCATION_ON"&$de&"BITMAP_ON"&$de&"REPARSE_POINT_ON"&$de&"EA_INFORMATION_ON"&$de&"EA_ON"&$de&"PROPERTY_SET_ON"&$de&"LOGGED_UTILITY_STREAM_ON"&$de&"DT_DataRun"
	ElseIf $dol2t Then
		$csv_header = "Date"&$de&"Time"&$de&"Timezone"&$de&"MACB"&$de&"Source"&$de&"SourceType"&$de&"Type"&$de&"User"&$de&"Host"&$de&"Short"&$de&"Desc"&$de&"Version"&$de&"Filename"&$de&"Inode"&$de&"Notes"&$de&"Format"&$de&"Extra"
	ElseIf $DoBodyfile Then
		$csv_header = "MD5"&$de&"name"&$de&"inode"&$de&"mode_as_string"&$de&"UID"&$de&"GID"&$de&"size"&$de&"atime"&$de&"mtime"&$de&"ctime"&$de&"rtime"
	EndIf
	FileWriteLine($csv, $csv_header & @CRLF)
EndFunc

Func _WriteCSVExtraHeader()
	Local $csv_extra_header
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
	$UTCconfig = $part1
	If StringRight($part1,2) = "15" Then $part1 = StringReplace($part1,".15",".25")
	If StringRight($part1,2) = "30" Then $part1 = StringReplace($part1,".30",".50")
	If StringRight($part1,2) = "45" Then $part1 = StringReplace($part1,".45",".75")
	$DeltaTest = $part1*36000000000
	Return $DeltaTest
EndFunc

Func _InjectTimestampFormat()
Local $Formats = "1|" & _
	"2|" & _
	"3|" & _
	"4|" & _
	"5|" & _
	"6|"
	GUICtrlSetData($ComboTimestampFormat, $Formats, "6")
EndFunc

Func _InjectTimestampPrecision()
Local $Precision = "None|" & _
	"MilliSec|" & _
	"NanoSec|"
	GUICtrlSetData($ComboTimestampPrecision, $Precision, "NanoSec")
EndFunc

Func _InjectRecordSize()
	Local $size = "1024|4096|"
	GUICtrlSetData($ComboRecordSize, $size, "1024")
EndFunc

Func _InjectOutputFormat()
	Local $formats = "all|log2timeline|bodyfile|"
	GUICtrlSetData($ComboOutputFormat, $formats, "all")
EndFunc

Func _TranslateTimestamp()
	Local $lPrecision, $lTimestamp, $lTimestampTmp
	$DateTimeFormat = StringLeft(GUICtrlRead($ComboTimestampFormat), 1)
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
	$lTimestamp = _WinTime_UTCFileTimeFormat(Dec($ExampleTimestampVal, 2), $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$lTimestamp = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$lTimestamp = $lTimestamp & $PrecisionSeparator2 & _FillZero(StringRight($lTimestampTmp, 4))
	EndIf
	GUICtrlSetData($InputExampleTimestamp, $lTimestamp)
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
;		$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\" & $Name,3,6,7)
		;$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\[0x" & Hex($CurrentProgress*$MFT_Record_Size,8) & "]" & $Name,3,6,7)
		If $RecordOffset <> "" Then
			$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\[" & $RecordOffset & "]" & $Name,3,6,7)
		Else
			$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\[__" & Hex(Random(1000000, 2000000, 1), 8) & "]" & $Name,3,6,7)
		EndIf
;		$hFile = _WinAPI_CreateFile("\\.\" & $OutputPath & "\" & $Name & "[0x" & Hex($CurrentProgress*1024,8) & "]",3,6,7)
        If $hFile Then
            _WinAPI_SetFilePointer($hFile, 0,$FILE_BEGIN)
            _WinAPI_WriteFile($hFile, DllStructGetPtr($xBuffer), $Size, $nBytes)
            _WinAPI_CloseHandle($hFile)
            If StringInStr($Name, $subst) Then _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
            Return
        Else
            If $zflag = 0 Then		;first pass
			   $mid = Int(StringLen($Name)/2)
			   $zPath = StringMid($Name, 1, StringInStr($Name, "\", 0, -1, $mid)-1)
			ElseIf $zflag = 1 Then		;second pass
			   _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
			   $Name = StringReplace($Name,$subst, $zPath)	;restore full name
			   $zPath = StringMid($Name, 1, StringInStr($Name, "\", 0, 1, $mid)-1)
			Else		;fail
			   _DebugOut("Error in creating resident file " & StringReplace($Name,$subst,$zPath), $record)
			   _WinAPI_DefineDosDevice($subst, 2, $zPath)     ;close spare
			   Return
			EndIf
			_WinAPI_DefineDosDevice($subst, 0, $zPath)     ;open spare
			$Name = StringReplace($Name,$zPath, $subst)
			$zflag += 1
		 EndIf
    Until $hFile
EndFunc

Func _SetOutputPath()
	$OutputPath = FileSelectFolder("Select path for output", "", 7, @ScriptDir)
	If @error Then
		$OutputPath = @ScriptDir
	EndIf
EndFunc

Func _GetPhysicalDrives($InputDevice)
	Local $PhysicalDriveString, $hFile0, $i=0
	GUICtrlSetData($Combo,"","")
	$Entries = ''
	GUICtrlSetData($ComboPhysicalDrives,"","")
	$sDrivePath = '\\.\'&$InputDevice
	If StringInStr($sDrivePath, "ShadowCopy") Then
		$sDrivePath = StringReplace($sDrivePath,"\.\","\?\")
	EndIf
	;ConsoleWrite("$sDrivePath: " & $sDrivePath & @CRLF)
	While 1
		If $i > 200 Then ExitLoop
		$hFile0 = _WinAPI_CreateFile($sDrivePath & $i,2,2,2)
		If $hFile0 <> 0 Then
			ConsoleWrite("Found: " & $sDrivePath & $i & @CRLF)
			_WinAPI_CloseHandle($hFile0)
			$PhysicalDriveString &= $sDrivePath&$i&"|"
		EndIf
		$i+=1
	WEnd
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
	Local $TimeZone
	For $i = 1 To $cmdline[0]
		;ConsoleWrite("Param " & $i & ": " & $cmdline[$i] & @CRLF)
		If StringLeft($cmdline[$i],8) = "/Volume:" Then $TargetDrive = StringMid($cmdline[$i],9)
		If StringLeft($cmdline[$i],9) = "/MftFile:" Then $TargetMftFile = StringMid($cmdline[$i],10)
		If StringLeft($cmdline[$i],12) = "/OutputPath:" Then $OutputPath = StringMid($cmdline[$i],13)
		If StringLeft($cmdline[$i],21) = "/ExtractResidentData:" Then $checkExtractResidentData = StringMid($cmdline[$i],22)
		If StringLeft($cmdline[$i],22) = "/ExtractResidentSlack:" Then $checkExtractResidentSlack = StringMid($cmdline[$i],23)
		If StringLeft($cmdline[$i],10) = "/TimeZone:" Then $TimeZone = StringMid($cmdline[$i],11)
		If StringLeft($cmdline[$i],14) = "/OutputFormat:" Then $sOutputFormat = StringMid($cmdline[$i],15)
		If StringLeft($cmdline[$i],12) = "/SkipFixups:" Then $checkFixups = StringMid($cmdline[$i],13)
		If StringLeft($cmdline[$i],11) = "/ScanSlack:" Then $checkBruteForceSlack = StringMid($cmdline[$i],12)
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

	If StringLen($MFT_Record_Size) > 0 Then
		$MFT_Record_Size = Number($MFT_Record_Size)
		If $MFT_Record_Size <> 1024 And $MFT_Record_Size <> 4096 Then
			ConsoleWrite("Error invalid record size: " & $MFT_Record_Size & @CRLF)
			Exit(1)
		EndIf
	Else
		$MFT_Record_Size = 1024
	EndIf

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

	$tDelta = _GetUTCRegion($TimeZone) - $tDelta
	If @error Then
		ConsoleWrite("Error: Timezone configuration failed." & @CRLF)
	Else
		ConsoleWrite("Timestamps presented in UTC: " & $UTCconfig & @CRLF)
	EndIf
	$tDelta = $tDelta * -1

	$IsPhysicalDrive = 0
	$IsImage = 0
	$IsShadowCopy = 0
	$IsMftFile = 0

	If StringLen($TargetMftFile) > 0 Then
		If Not FileExists($TargetMftFile) Then
			ConsoleWrite("Error input $MFT file does not exist." & @CRLF)
			Exit(1)
		EndIf
		$IsMftFile = 1
		$hDisk = _WinAPI_CreateFile("\\.\" & $TargetMftFile, 2, 2, 2)
		If $hDisk = 0 Then
			_DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
			Exit(1)
		EndIf
		$MftFileSize = _WinAPI_GetFileSizeEx($hDisk)
	EndIf

	If StringLen($TargetDrive) > 0 Then
		If $IsMftFile Then
			ConsoleWrite("Error multiple input files" & @CRLF)
			Exit(1)
		EndIf
		If StringLen($TargetDrive) <> 2 Then
			ConsoleWrite("Error input volume in bad format." & @CRLF)
			Exit(1)
		EndIf
		$hDisk = _WinAPI_CreateFile("\\.\" & $TargetDrive, 2, 2, 6)
		If $hDisk = 0 Then
			_DebugOut("CreateFile: " & _WinAPI_GetLastErrorMessage())
			Exit(1)
		EndIf
	EndIf

	If Not $hDisk Then
		_DebugOut("Error: invalid handle")
		Exit(1)
	EndIf

	If StringLen($sOutputFormat) > 0 Then
		If $sOutputFormat <> "all" And $sOutputFormat <> "all" And $sOutputFormat <> "all" Then
			_DebugOut("Error: invalid output format: " & $sOutputFormat)
			Exit(1)
		EndIf
	Else
		$sOutputFormat = "all"
	EndIf

	If Not FileExists($OutputPath) Then
		DirCreate($OutputPath)
		If Not FileExists($OutputPath) Then
			$OutputPath = @ScriptDir
		EndIf
	EndIf

	If StringLen($PrecisionSeparator) <> 1 Then $PrecisionSeparator = "."
	If StringLen($SeparatorInput) <> 1 Then $SeparatorInput = "|"

	If StringLen($TimestampPrecision) > 0 Then
		Select
			Case $TimestampPrecision = "None"
;				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
				$TimestampPrecision = 1
			Case $TimestampPrecision = "MilliSec"
;				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
				$TimestampPrecision = 2
			Case $TimestampPrecision = "NanoSec"
;				_DebugOut("Timestamp Precision: " & $TimestampPrecision)
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

Func _DecodeMacFromGuid($Input)
	If StringLen($Input) <> 12 Then Return SetError(1)
	Local $Mac = StringMid($Input,1,2) & "-" & StringMid($Input,3,2) & "-" & StringMid($Input,5,2) & "-" & StringMid($Input,7,2) & "-" & StringMid($Input,9,2) & "-" & StringMid($Input,11,2)
	Return $Mac
EndFunc

Func _DecodeTimestampFromGuid($StampDecode)
	$StampDecode = _SwapEndian($StampDecode)
	$StampDecode_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $StampDecode)
	$StampDecode = _WinTime_UTCFileTimeFormat(Dec($StampDecode,2) - $tDelta - $TimeDiff, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$StampDecode = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$StampDecode = $StampDecode & $PrecisionSeparator2 & _FillZero(StringRight($StampDecode_tmp, 4))
	EndIf
	Return $StampDecode
EndFunc

Func _WofCompressedDataCompressionType($value)
	Select
		Case $value = 0
			Return "XPRESS4K"
		Case $value = 1
			Return "LZX"
		Case $value = 2
			Return "XPRESS8K"
		Case $value = 3
			Return "XPRESS16K"
		Case Else
			Return "unknown"
	EndSelect
EndFunc

Func _DecodeAppExecLink($sHex)
;	ConsoleWrite("_DecodeAppExecLink(): " & @crlf)
;	ConsoleWrite("$sHex: " & $sHex & @crlf)
	Local $version = StringMid($sHex, 1, 8)
	$version = Dec(_SwapEndian($version))
;	ConsoleWrite("$version: " & $version & @crlf)
	Local $pBase = DllStructCreate("byte[" & (StringLen($sHex) - 8) / 2 & "]")
	DllStructSetData($pBase, 1, "0x" & StringMid($sHex, 9))
	Local $pData = DllStructCreate("wchar[" & DllStructGetSize($pBase) / 2 & "]", DllStructGetPtr($pBase))
	Local $packageId = DllStructGetData($pData, 1)
;	ConsoleWrite("$packageId: " & $packageId & @crlf)
	Local $ptr = (StringLen($packageId) * 2) + 2 ; add 2 bytes for null termination
	$pData = DllStructCreate("wchar[" & (DllStructGetSize($pBase) - $ptr) / 2 & "]", DllStructGetPtr($pBase) + $ptr)
	Local $entryPoint = DllStructGetData($pData, 1)
;	ConsoleWrite("$entryPoint: " & $entryPoint & @crlf)
	$ptr += (StringLen($entryPoint) * 2) + 2 ; add 2 bytes for null termination
	$pData = DllStructCreate("wchar[" & (DllStructGetSize($pBase) - $ptr) / 2 & "]", DllStructGetPtr($pBase) + $ptr)
	Local $executable = DllStructGetData($pData, 1)
;	ConsoleWrite("$executable: " & $executable & @crlf)
	$ptr += (StringLen($executable) * 2) + 2 ; add 2 bytes for null termination
	$pData = DllStructCreate("wchar[" & (DllStructGetSize($pBase) - $ptr) / 2 & "]", DllStructGetPtr($pBase) + $ptr)
	Local $applicationType = DllStructGetData($pData, 1)
;	ConsoleWrite("$applicationType: " & $applicationType & @crlf)
	FileWriteLine($ReparsePointAppExecLinkCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $version & $de & $packageId & $de & $entryPoint & $de & $executable & $de & $applicationType & @CRLF)
	Return $executable
EndFunc

Func _Get_ReparsePoint($Entry,$LocalAttributeOffset,$LocalAttributeSize)
	Local $GuidPresent=0,$ReparseType,$ReparseData,$ReparseDataLength,$ReparseGuid,$ReparseSubstituteNameOffset,$ReparseSubstituteNameLength,$ReparsePrintNameOffset,$ReparsePrintNameLength,$ReparseSubstituteName,$ReparsePrintName

	$Entry = StringMid($Entry,$LocalAttributeOffset+48,($LocalAttributeSize*2)-48)
	;ConsoleWrite("_Get_ReparsePoint(): " & @crlf)
	;ConsoleWrite(_HexEncode("0x"&$Entry) & @crlf)
	$LocalAttributeOffset = 1
	$ReparseType = StringMid($Entry,$LocalAttributeOffset,8)
	$ReparseType = _SwapEndian($ReparseType)
	If Dec(StringMid($ReparseType,1,2)) < 128 Then ;Non-Microsoft - GUID exist
		$GuidPresent = 1
	EndIf
	$ReparseType = "0x" & $ReparseType
	$ReparseType = _GetReparseType($ReparseType)
	$ReparseDataLength = StringMid($Entry,$LocalAttributeOffset+8,4)
	$ReparseDataLength = Dec(_SwapEndian($ReparseDataLength),2)
	If $ReparseType = "WCI" Then
		$ReparseGuid = StringMid($Entry,$LocalAttributeOffset+32,32)
		$ReparseGuid = _HexToGuidStr($ReparseGuid,1)
		$ReparsePrintNameLength = StringMid($Entry,$LocalAttributeOffset+64,4)
		$ReparsePrintNameLength = Dec(_SwapEndian($ReparsePrintNameLength))
		If $ReparsePrintNameLength > 0 Then
			$ReparsePrintName = StringMid($Entry,($LocalAttributeOffset+68),$ReparsePrintNameLength*2)
			$ReparsePrintName = BinaryToString("0x"&$ReparsePrintName,2)
		EndIf

	ElseIf $ReparseType = "WOF" Then
		; the format does not really fit the csv column, just put the translated compression type here
		$ReparseData = StringMid($Entry,$LocalAttributeOffset+16,$ReparseDataLength*2)
		$ReparseData = StringMid($ReparseData, 25)
		$ReparseData = _WofCompressedDataCompressionType(Dec(_SwapEndian($ReparseData)))
		;ConsoleWrite("$ReparseData: " & $ReparseData & @crlf)
	ElseIf $ReparseType = "APPEXECLINK" Then
		$ReparseData = StringMid($Entry,$LocalAttributeOffset+16,$ReparseDataLength*2)
		$ReparseData = _DecodeAppExecLink($ReparseData)
		;$ReparseData = ""
	Else
		If $GuidPresent Then
			$ReparseGuid = StringMid($Entry,$LocalAttributeOffset+16,32)
			$ReparseGuid = _HexToGuidStr($ReparseGuid,1)
			$ReparseData = StringMid($Entry,$LocalAttributeOffset+48,$ReparseDataLength*2)
		Else
			$ReparseData = StringMid($Entry,$LocalAttributeOffset+16,$ReparseDataLength*2)
		EndIf

		$ReparseSubstituteNameOffset = StringMid($ReparseData,1,4)
		$ReparseSubstituteNameOffset = Dec(_SwapEndian($ReparseSubstituteNameOffset),2)
		$ReparseSubstituteNameLength = StringMid($ReparseData,5,4)
		$ReparseSubstituteNameLength = Dec(_SwapEndian($ReparseSubstituteNameLength),2)
		$ReparsePrintNameOffset = StringMid($ReparseData,9,4)
		$ReparsePrintNameOffset = Dec(_SwapEndian($ReparsePrintNameOffset),2)
		If $ReparseType = "SYMLINK" Then
			;??
			$ReparsePrintNameOffset += 4
		EndIf
		$ReparsePrintNameLength = StringMid($ReparseData,13,4)
		$ReparsePrintNameLength = Dec(_SwapEndian($ReparsePrintNameLength),2)
		;-----if $ReparseSubstituteNameOffset<>0 then the order is reversed and parsed from end of $ReparseData ????????
		If StringMid($ReparseData,1,4) <> "0000" Then
			$ReparseSubstituteName = StringMid($Entry,StringLen($Entry)+1-($ReparseSubstituteNameLength*2),$ReparseSubstituteNameLength*2)
;-			ConsoleWrite("$ReparseSubstituteName: " & @crlf)
;-			ConsoleWrite(_HexEncode("0x"&$ReparseSubstituteName) & @crlf)
			$ReparseSubstituteName = BinaryToString("0x"&$ReparseSubstituteName,2)
			$ReparsePrintName = StringMid($Entry,StringLen($Entry)+1-($ReparseSubstituteNameLength*2)-($ReparsePrintNameLength*2),$ReparsePrintNameLength*2)
;-			ConsoleWrite("$ReparsePrintName: " & @crlf)
;-			ConsoleWrite(_HexEncode("0x"&$ReparsePrintName) & @crlf)
			$ReparsePrintName = BinaryToString("0x"&$ReparsePrintName,2)
		Else
;-			ConsoleWrite("2: " & @crlf)
			If $ReparseType = "SYMLINK" Then
				$ReparseSubstituteName = StringMid($Entry,$LocalAttributeOffset+16+24,$ReparseSubstituteNameLength*2)
			Else
				$ReparseSubstituteName = StringMid($Entry,$LocalAttributeOffset+16+16,$ReparseSubstituteNameLength*2)
			EndIf
;-			ConsoleWrite("$ReparseSubstituteName: " & @crlf)
;-			ConsoleWrite(_HexEncode("0x"&$ReparseSubstituteName) & @crlf)
			$ReparseSubstituteName = BinaryToString("0x"&$ReparseSubstituteName,2)
			$ReparsePrintName = StringMid($Entry,($LocalAttributeOffset+32)+($ReparsePrintNameOffset*2),$ReparsePrintNameLength*2)
;-			ConsoleWrite("$ReparsePrintName: " & @crlf)
;-			ConsoleWrite(_HexEncode("0x"&$ReparsePrintName) & @crlf)
			$ReparsePrintName = BinaryToString("0x"&$ReparsePrintName,2)
		EndIf
		$ReparseData = ""
	EndIf
	FileWriteLine($ReparsePointCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $ReparseType & $de & $ReparseGuid & $de & $ReparseData & $de & $ReparseSubstituteName & $de & $ReparsePrintName & @CRLF)
EndFunc

Func _DecodeCiCataloghint($EaValue)
	; for any decode issue, return input
	Local $length = StringMid($EaValue, 5, 4)
	$length = Dec(_SwapEndian($length))
	If $length = 0 Then Return $EaValue
	Local $value = _HexToString(StringMid($EaValue, 9, $length*2))
	If StringLen($value) = 0 Then Return $EaValue
	Return $value
EndFunc

Func _Get_Ea($Entry,$LocalAttributeOffset,$LocalAttributeSize)
	Local $OffsetToNextEa,$EaFlags,$EaNameLength,$EaValueLength,$EaCounter=1

	;ConsoleWrite("_Get_Ea()" & @CRLF)
	$Entry = StringMid($Entry,$LocalAttributeOffset+48,($LocalAttributeSize*2)-48)
	;ConsoleWrite(_HexEncode("0x"&$Entry) & @crlf)
	$StringLengthInput = StringLen($Entry)
	$LocalAttributeOffset = 1
	$OffsetToNextEa = StringMid($Entry,$LocalAttributeOffset,8)
	$OffsetToNextEa = Dec(_SwapEndian($OffsetToNextEa),2)
	$EaFlags = "0x" & StringMid($Entry,$LocalAttributeOffset+8,2)
	$EaNameLength = Dec(StringMid($Entry,$LocalAttributeOffset+10,2))
	$EaValueLength = StringMid($Entry,$LocalAttributeOffset+12,4)
	$EaValueLength = Dec(_SwapEndian($EaValueLength),2)
	$EaName = StringMid($Entry,$LocalAttributeOffset+16,$EaNameLength*2)
	$EaName = _HexToString($EaName)
	$EaValue = StringMid($Entry,$LocalAttributeOffset+16+($EaNameLength*2)+2,$EaValueLength*2)
	If $EaName = "$CI.CATALOGHINT" Then
		$EaValue = _DecodeCiCataloghint($EaValue)
	EndIf
	;ConsoleWrite("$OffsetToNextEa = " & $OffsetToNextEa & @crlf)
	;ConsoleWrite("$EaFlags = " & $EaFlags & @crlf)
	;ConsoleWrite("$EaNameLength = " & $EaNameLength & @crlf)
	;ConsoleWrite("$EaValueLength = " & $EaValueLength & @crlf)
	;ConsoleWrite("$EaName = " & $EaName & @crlf)
	;ConsoleWrite("$EaValue:" & @crlf)
	;ConsoleWrite(_HexEncode("0x"&$EaValue) & @crlf)

	FileWriteLine($EaCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $EaCounter & $de & $EaFlags & $de & $EaName & $de & $EaValueLength & $de & $EaValue & @CRLF)

	If $OffsetToNextEa*2 >= $StringLengthInput Then
		Return
	EndIf

	Do
		$LocalAttributeOffset += $OffsetToNextEa*2
		If $LocalAttributeOffset >= $StringLengthInput Then ExitLoop
		$EaCounter+=1
		$OffsetToNextEa = StringMid($Entry,$LocalAttributeOffset,8)
		$OffsetToNextEa = Dec(_SwapEndian($OffsetToNextEa),2)
		$EaFlags = "0x" & StringMid($Entry,$LocalAttributeOffset+8,2)
		$EaNameLength = Dec(StringMid($Entry,$LocalAttributeOffset+10,2))
		$EaValueLength = StringMid($Entry,$LocalAttributeOffset+12,4)
		$EaValueLength = Dec(StringMid($EaValueLength,3,2) & StringMid($EaValueLength,1,2))
		If $EaNameLength = 0 Or $EaValueLength = 0 Then ExitLoop
		$EaName = StringMid($Entry,$LocalAttributeOffset+16,$EaNameLength*2)
		$EaName = _HexToString($EaName)
		$EaValue = StringMid($Entry,$LocalAttributeOffset+16+($EaNameLength*2),$EaValueLength*2)
		If $EaName = "$CI.CATALOGHINT" Then
			$EaValue = _DecodeCiCataloghint($EaValue)
		EndIf
		;ConsoleWrite("$EaFlags = " & $EaFlags & @crlf)
		;ConsoleWrite("$EaNameLength = " & $EaNameLength & @crlf)
		;ConsoleWrite("$EaValueLength = " & $EaValueLength & @crlf)
		;ConsoleWrite("$EaName = " & $EaName & @crlf)
		;ConsoleWrite("$EaValue: " & @crlf)
		;ConsoleWrite(_HexEncode("0x"&$EaValue) & @crlf)

		FileWriteLine($EaCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $EaCounter & $de & $EaFlags & $de & $EaName & $de & $EaValueLength & $de & $EaValue & @CRLF)

	Until $LocalAttributeOffset >= $StringLengthInput
EndFunc

Func _Get_LoggedUtilityStream($Entry,$CurrentAttributeName)
	Local $TheLoggedUtilityStream, $LocalAttributeOffset = 1

	If $Entry <> "" Then
		$TheLoggedUtilityStream = StringMid($Entry,$LocalAttributeOffset)
	EndIf

	;ConsoleWrite("_Get_LoggedUtilityStream():" & @CRLF)
	;ConsoleWrite("$TheLoggedUtilityStream = " & $TheLoggedUtilityStream & @crlf)

	FileWriteLine($LoggedUtilityStreamCsvFile, $HDR_MFTREcordNumber & $de & $HDR_SequenceNo & $de & $CurrentAttributeName & $de & BinaryLen("0x"&$TheLoggedUtilityStream) & @CRLF)

	If $TheLoggedUtilityStream <> "" And $CurrentAttributeName = "$TXF_DATA" Then
		_Decode_TXF_DATA($TheLoggedUtilityStream)
	EndIf
EndFunc

Func _GetAttributeEntry($Entry)
	Local $CoreAttribute,$CoreAttributeArr[3]
	Local $RunListOffset
	Local $ATTRIBUTE_HEADER_LengthOfAttribute,$ATTRIBUTE_HEADER_OffsetToAttribute,$ATTRIBUTE_HEADER_Length, $ATTRIBUTE_HEADER_NonResidentFlag, $ATTRIBUTE_HEADER_NameLength, $ATTRIBUTE_HEADER_NameRelativeOffset, $ATTRIBUTE_HEADER_Name
	$ATTRIBUTE_HEADER_Length = StringMid($Entry,9,8)
	$ATTRIBUTE_HEADER_Length = Dec(_SwapEndian($ATTRIBUTE_HEADER_Length),2)
	$ATTRIBUTE_HEADER_NonResidentFlag = Dec(StringMid($Entry,17,2))
	$ATTRIBUTE_HEADER_NameLength = Dec(StringMid($Entry,19,2))
	$ATTRIBUTE_HEADER_NameRelativeOffset = StringMid($Entry,21,4)
	$ATTRIBUTE_HEADER_NameRelativeOffset = Dec(_SwapEndian($ATTRIBUTE_HEADER_NameRelativeOffset))
	If $ATTRIBUTE_HEADER_NameLength > 0 Then
		$ATTRIBUTE_HEADER_Name = BinaryToString("0x"&StringMid($Entry,$ATTRIBUTE_HEADER_NameRelativeOffset*2 + 1,$ATTRIBUTE_HEADER_NameLength*4),2)
	Else
		$ATTRIBUTE_HEADER_Name = ""
	EndIf
	If $ATTRIBUTE_HEADER_NonResidentFlag = 0 Then
		$ATTRIBUTE_HEADER_LengthOfAttribute = StringMid($Entry,33,8)
		$ATTRIBUTE_HEADER_LengthOfAttribute = Dec(_SwapEndian($ATTRIBUTE_HEADER_LengthOfAttribute),2)
		$ATTRIBUTE_HEADER_OffsetToAttribute = Dec(_SwapEndian(StringMid($Entry,41,4)))
		$CoreAttribute = StringMid($Entry,$ATTRIBUTE_HEADER_OffsetToAttribute*2+1,$ATTRIBUTE_HEADER_LengthOfAttribute*2)
	Else
		$CoreAttribute = ""
		If $ATTRIBUTE_HEADER_Name <> "" Then
			$RunListOffset = StringMid($Entry,65,4)
	;		ConsoleWrite("$RunListOffset = " & $RunListOffset & @crlf)
			$RunListOffset = Dec(_SwapEndian($RunListOffset))
	;		ConsoleWrite("$RunListOffset = " & $RunListOffset & @crlf)
			$DT_DataRun = StringMid($Entry,$RunListOffset*2+1,(StringLen($Entry)-$RunListOffset)*2)
	;		ConsoleWrite("$DataRun = " & $DataRun & @crlf)
		EndIf
	EndIf
	$CoreAttributeArr[0] = $CoreAttribute
	$CoreAttributeArr[1] = $ATTRIBUTE_HEADER_Name
	$CoreAttributeArr[2] = $ATTRIBUTE_HEADER_NonResidentFlag
	Return $CoreAttributeArr
EndFunc

Func _Decode_TXF_DATA($InputData)
	Local $StartOffset = 1, $MftRef_RM_Root, $MftRefSeqNo_RM_Root, $UsnIndex, $TxfFileId, $LsnUserData, $LsnNtfsMetadata, $LsnDirectoryIndex, $UnknownFlag

	;ConsoleWrite("_Decode_TXF_DATA():" & @CRLF)
	;ConsoleWrite(_HexEncode("0x"&$InputData) & @CRLF)

	$MftRef_RM_Root = StringMid($InputData, $StartOffset, 12)
	$MftRef_RM_Root = Dec(_SwapEndian($MftRef_RM_Root),2)
	$MftRefSeqNo_RM_Root = StringMid($InputData, $StartOffset + 12, 4)
	$MftRefSeqNo_RM_Root = Dec(_SwapEndian($MftRefSeqNo_RM_Root),2)

	$UsnIndex = StringMid($InputData, $StartOffset + 16, 16)
	$UsnIndex = "0x"&_SwapEndian($UsnIndex)

	;Increments with 1. The last TxfFileId is referenced in $Tops standard $DATA stream at offset 0x28
	$TxfFileId = StringMid($InputData, $StartOffset + 32, 16)
	$TxfFileId = "0x"&_SwapEndian($TxfFileId)

	;Offset into $TxfLogContainer00000000000000000001
	$LsnUserData = StringMid($InputData, $StartOffset + 48, 16)
	$LsnUserData = "0x"&_SwapEndian($LsnUserData)

	;Offset into $TxfLogContainer00000000000000000001
	$LsnNtfsMetadata = StringMid($InputData, $StartOffset + 64, 16)
	$LsnNtfsMetadata = "0x"&_SwapEndian($LsnNtfsMetadata)

	$LsnDirectoryIndex = StringMid($InputData, $StartOffset + 80, 16)
	$LsnDirectoryIndex = "0x"&_SwapEndian($LsnDirectoryIndex)

	$UnknownFlag = StringMid($InputData, $StartOffset + 96, 16)
	$UnknownFlag = "0x"&_SwapEndian($UnknownFlag)

	;ConsoleWrite("$MftRef_RM_Root: " & $MftRef_RM_Root & @CRLF)
	;ConsoleWrite("$MftRefSeqNo_RM_Root: " & $MftRefSeqNo_RM_Root & @CRLF)
	;ConsoleWrite("$UsnIndex: " & $UsnIndex & @CRLF)
	;ConsoleWrite("$TxfFileId: " & $TxfFileId & @CRLF)
	;ConsoleWrite("$LsnUserData: " & $LsnUserData & @CRLF)
	;ConsoleWrite("$LsnNtfsMetadata: " & $LsnNtfsMetadata & @CRLF)
	;ConsoleWrite("$LsnDirectoryIndex: " & $LsnDirectoryIndex & @CRLF)

	FileWriteLine($LoggedUtilityStreamTxfDataCsvFile, $HDR_MFTREcordNumber&$de&$HDR_SequenceNo&$de&$MftRef_RM_Root&$de&$MftRefSeqNo_RM_Root&$de&$UsnIndex&$de&$TxfFileId&$de&$LsnUserData&$de&$LsnNtfsMetadata&$de&$LsnDirectoryIndex&$de&$UnknownFlag)

EndFunc

Func _Get_IndexRoot($Entry, $IndxType)
;	ConsoleWrite("_Get_IndexRoot() " & @CRLF)
	Local $LocalAttributeOffset = 1,$CollationRule,$SizeOfIndexAllocationEntry

	$CollationRule = StringMid($Entry,$LocalAttributeOffset+8,8)
	$CollationRule = _SwapEndian($CollationRule)
	$SizeOfIndexAllocationEntry = StringMid($Entry,$LocalAttributeOffset+16,8)
	$SizeOfIndexAllocationEntry = Dec(_SwapEndian($SizeOfIndexAllocationEntry),2)
;	$ClustersPerIndexRoot = Dec(StringMid($Entry,$LocalAttributeOffset+24,2))
;	$IRPadding = StringMid($Entry,$LocalAttributeOffset+26,6)
	$OffsetToFirstEntry = StringMid($Entry,$LocalAttributeOffset+32,8)
	$OffsetToFirstEntry = Dec(_SwapEndian($OffsetToFirstEntry),2)
	$TotalSizeOfEntries = StringMid($Entry,$LocalAttributeOffset+40,8)
	$TotalSizeOfEntries = Dec(_SwapEndian($TotalSizeOfEntries),2)
	$AllocatedSizeOfEntries = StringMid($Entry,$LocalAttributeOffset+48,8)
	$AllocatedSizeOfEntries = Dec(_SwapEndian($AllocatedSizeOfEntries),2)
	$Flags = StringMid($Entry,$LocalAttributeOffset+56,2)
	If $Flags = "01" Then
		$Flags = "01 (Index Allocation needed)"
	Else
		$Flags = "00 (Fits in Index Root)"
	EndIf

	$TheResidentIndexEntry = StringMid($Entry,$LocalAttributeOffset+64,($TotalSizeOfEntries*2)-64)

	If $IndxType = 1 Then
		_ScanModeI30ProcessPage($TheResidentIndexEntry, 0)
	Else
		_DebugOut("Error: Unsupported indx type: " & $IndxType)
	EndIf

EndFunc

Func _ScanModeI30ProcessPage($TargetPage,$isSlack)
;	ConsoleWrite("_ScanModeI30ProcessPage()" & @CRLF)
;	ConsoleWrite(_HexEncode("0x" & $TargetPage) & @CRLF)
	Local $LocalEntryCounter = 0, $NextOffset = 1, $TotalSizeOfPage = StringLen($TargetPage)
	Do
;		_DumpOutput("$NextOffset: " & $NextOffset & @CRLF)
;		ConsoleWrite("$NextOffset: 0x" & Hex(Int($OffsetFile + ($OffsetChunk + $NextOffset)/2)) & @CRLF)
		$SizeOfNextEntry = StringMid($TargetPage,$NextOffset+16,4)
		$SizeOfNextEntry = Dec(_SwapEndian($SizeOfNextEntry),2)
		$SizeOfNextEntry = $SizeOfNextEntry*2
		$SizeOfNextEntryTmp = $SizeOfNextEntry

		$NextEntry = StringMid($TargetPage,$NextOffset,$SizeOfNextEntryTmp)
		If _ScanModeI30DecodeEntry($NextEntry) Then
;			$OffsetRecord = "0x" & Hex(Int($OffsetFile + ($OffsetChunk + $NextOffset)/2))
			If _NormalModeI30DecodeEntry($NextEntry, $isSlack) Then
				$LocalEntryCounter += 1
			Else
;				ConsoleWrite("Error: " & @error & @CRLF)
			EndIf
			If $SizeOfNextEntryTmp > $SizeOfNextEntry Then
				$NextOffset+=2
			Else
				$NextOffset+=$SizeOfNextEntry
			EndIf
		Else
			If Not StringRegExp(StringMid($TargetPage,$NextOffset),$RegExPattern) Then
;				ConsoleWrite("The data on the rest of this page is just 00. Nothing to do here from offset 0x" & Hex(Int($OffsetFile + ($OffsetChunk + $NextOffset)/2)) & @CRLF)
				Return $LocalEntryCounter
			EndIf
			$NextOffset+=2
		EndIf

	Until $NextOffset > $TotalSizeOfPage
	Return $LocalEntryCounter
EndFunc

Func _ScanModeI30DecodeEntry($Record)
;	ConsoleWrite("_ScanModeI30DecodeEntry() " & @CRLF)
;	ConsoleWrite(_HexEncode("0x" & $Record) & @CRLF)
	Local $ScanMode = 2, $ExtendedTimestampCheck = 1, $ExtendedNameCheckAll = 1, $ExtendedNameCheckChar = 1, $ExtendedNameCheckWindows = 1
	$MFTReference = StringMid($Record,1,12)
	If $MFTReference = "FFFFFFFFFFFF" Then Return SetError(1,0,0)
	$MFTReference = Dec(_SwapEndian($MFTReference),2)
	If $ScanMode < 1 Then
		If $MFTReference = 0 Then Return SetError(1,0,0)
	EndIf
	$MFTReferenceSeqNo = StringMid($Record,13,4)
	$MFTReferenceSeqNo = Dec(_SwapEndian($MFTReferenceSeqNo),2)
	If $ScanMode < 1 Then
		If $MFTReferenceSeqNo = 0 Then Return SetError(2,0,0)
	EndIf
	$IndexEntryLength = StringMid($Record,17,4)
	$IndexEntryLength = Dec(_SwapEndian($IndexEntryLength),2)
	If $ScanMode < 2 Then
		If ($IndexEntryLength = 0) Or ($IndexEntryLength = 0xFFFF) Then Return SetError(3,0,0)
	EndIf
	;$OffsetToFileName = StringMid($Record,21,4)
	;$OffsetToFileName = Dec(_SwapEndian($OffsetToFileName),2)
	;If $OffsetToFileName <> 82 Then Return SetError(4,0,0)
	$IndexFlags = StringMid($Record,25,4)
	$IndexFlags = Dec(_SwapEndian($IndexFlags),2)
	If $ScanMode < 3 Then
		If $IndexFlags > 2 Then Return SetError(5,0,0)
	EndIf

	$Padding = StringMid($Record,29,4)
	If $ScanMode < 4 Then
		If $Padding <> "0000" Then Return SetError(6,0,0)
	EndIf
	$MFTReferenceOfParent = StringMid($Record,33,12)
	$MFTReferenceOfParent = Dec(_SwapEndian($MFTReferenceOfParent),2)
	If $ScanMode < 5 Then
		If $MFTReferenceOfParent < 5 Then Return SetError(7,0,0)
	EndIf
	$MFTReferenceOfParentSeqNo = StringMid($Record,45,4)
	$MFTReferenceOfParentSeqNo = Dec(_SwapEndian($MFTReferenceOfParentSeqNo),2)
	If $ScanMode < 5 Then
		If $MFTReferenceOfParentSeqNo = 0 Then Return SetError(8,0,0)
	EndIf
	$CTime_Timestamp = StringMid($Record,49,16)
	If $ExtendedTimestampCheck Then
		$CTime_TimestampTmp = Dec(_SwapEndian($CTime_Timestamp),2)
		If $CTime_TimestampTmp < 112589990684262400 Or $CTime_TimestampTmp > 139611588448485376 Then Return SetError(9,0,0) ;14 oktober 1957 - 31 mai 2043
	EndIf
	$CTime_Timestamp = _DecodeTimestamp($CTime_Timestamp)
	If $CTime_Timestamp = $TimestampErrorVal Then Return SetError(10,0,0)
	$ATime_Timestamp = StringMid($Record,65,16)
	If $ExtendedTimestampCheck Then
		$ATime_TimestampTmp = Dec(_SwapEndian($ATime_Timestamp),2)
		If $ATime_TimestampTmp < 112589990684262400 Or $ATime_TimestampTmp > 139611588448485376 Then Return SetError(11,0,0) ;14 oktober 1957 - 31 mai 2043
	EndIf
	$ATime_Timestamp = _DecodeTimestamp($ATime_Timestamp)
	If $ATime_Timestamp = $TimestampErrorVal Then Return SetError(12,0,0)
	$MTime_Timestamp = StringMid($Record,81,16)
	If $ExtendedTimestampCheck Then
		$MTime_TimestampTmp = Dec(_SwapEndian($MTime_Timestamp),2)
		If $MTime_TimestampTmp < 112589990684262400 Or $MTime_TimestampTmp > 139611588448485376 Then Return SetError(13,0,0) ;14 oktober 1957 - 31 mai 2043
	EndIf
	$MTime_Timestamp = _DecodeTimestamp($MTime_Timestamp)
	;-----------------------
	If $MTime_Timestamp = $TimestampErrorVal Then Return SetError(14,0,0)
	;--------------------------
	$RTime_Timestamp = StringMid($Record,97,16)
	If $ExtendedTimestampCheck Then
		$RTime_TimestampTmp = Dec(_SwapEndian($RTime_Timestamp),2)
		If $RTime_TimestampTmp < 112589990684262400 Or $RTime_TimestampTmp > 139611588448485376 Then Return SetError(15,0,0) ;14 oktober 1957 - 31 mai 2043
	EndIf
	$RTime_Timestamp = _DecodeTimestamp($RTime_Timestamp)
	If $RTime_Timestamp = $TimestampErrorVal Then Return SetError(16,0,0)
	$Indx_AllocSize = StringMid($Record,113,16)
	$Indx_AllocSize = Dec(_SwapEndian($Indx_AllocSize),2)
	If $Indx_AllocSize > 281474976710655 Then ;0xFFFFFFFFFFFF
		Return SetError(17,0,0)
	EndIf
	If $Indx_AllocSize > 0 And Mod($Indx_AllocSize,8) Then
		Return SetError(17,0,0)
	EndIf
	$Indx_RealSize = StringMid($Record,129,16)
	$Indx_RealSize = Dec(_SwapEndian($Indx_RealSize),2)
	If $Indx_RealSize > 281474976710655 Then ;0xFFFFFFFFFFFF
		Return SetError(18,0,0)
	EndIf
	If $Indx_RealSize > $Indx_AllocSize Then Return SetError(18,0,0)

	$Indx_File_Flags = StringMid($Record,145,8)
	$Indx_File_Flags = _SwapEndian($Indx_File_Flags)

	If BitAND("0x" & $Indx_File_Flags, 0x40000) Then
		$DoReparseTag=0
		$DoEaSize=1
	Else
		$DoReparseTag=1
		$DoEaSize=0
	EndIf
	$Indx_File_Flags = _File_Attributes("0x" & $Indx_File_Flags)

	Select
		Case $DoReparseTag
			$Indx_EaSize = ""
			$Indx_ReparseTag = StringMid($Record,153,8)
			$Indx_ReparseTag = _SwapEndian($Indx_ReparseTag)
			$Indx_ReparseTag = _GetReparseType("0x"&$Indx_ReparseTag)
			If StringInStr($Indx_ReparseTag,"UNKNOWN") Then Return SetError(19,0,0)
		Case $DoEaSize
			$Indx_ReparseTag = ""
			$Indx_EaSize = StringMid($Record,153,8)
			$Indx_EaSize = Dec(_SwapEndian($Indx_EaSize),2)
			If $Indx_EaSize < 8 Then Return SetError(19,0,0)
	EndSelect

	$Indx_NameLength = StringMid($Record,161,2)
	$Indx_NameLength = Dec($Indx_NameLength)
	If $Indx_NameLength = 0 Then Return SetError(20,0,0)
	$Indx_NameSpace = StringMid($Record,163,2)
	Select
		Case $Indx_NameSpace = "00"	;POSIX
			$Indx_NameSpace = "POSIX"
		Case $Indx_NameSpace = "01"	;WIN32
			$Indx_NameSpace = "WIN32"
		Case $Indx_NameSpace = "02"	;DOS
			$Indx_NameSpace = "DOS"
		Case $Indx_NameSpace = "03"	;DOS+WIN32
			$Indx_NameSpace = "DOS+WIN32"
		Case Else
			$Indx_NameSpace = "Unknown"
	EndSelect
	If $Indx_NameSpace = "Unknown" Then Return SetError(21,0,0)
	$Indx_FileName = StringMid($Record,165,$Indx_NameLength*4)
	$NameTest = 1
	Select
		Case $ExtendedNameCheckAll
;			_DumpOutput("$ExtendedNameCheckAll: " & $ExtendedNameCheckAll & @CRLF)
			$NameTest = _ValidateCharacterAndWindowsFileName($Indx_FileName)
		Case $ExtendedNameCheckChar
;			_DumpOutput("$ExtendedNameCheckChar: " & $ExtendedNameCheckChar & @CRLF)
			$NameTest = _ValidateCharacter($Indx_FileName)
		Case $ExtendedNameCheckWindows
;			_DumpOutput("$ExtendedNameCheckWindows: " & $ExtendedNameCheckWindows & @CRLF)
			$NameTest = _ValidateWindowsFileName($Indx_FileName)
	EndSelect
	If Not $NameTest Then Return SetError(22,0,0)
	$Indx_FileName = BinaryToString("0x"&$Indx_FileName,2)

	If @error Or $Indx_FileName = "" Then Return SetError(23,0,0)
	Return 1
EndFunc

Func _NormalModeI30DecodeEntry($InputData, $isSlack)
;	ConsoleWrite("_NormalModeI30DecodeEntry() " & @CRLF)
;	ConsoleWrite(_HexEncode("0x" & $InputData) & @CRLF)
	Local $LocalOffset = 1, $ScanMode = 2, $ExtendedTimestampCheck = 1, $ExtendedNameCheckAll= 1, $ExtendedNameCheckChar = 1, $ExtendedNameCheckWindows = 1
	$TextInformation=""
	;$RecordOffset = "0x" & Hex(Int($CurrentFileOffset + (($LocalOffset-1)/2)))
	;$RecordOffset = $OffsetRecord
	$MFTReference = StringMid($InputData,$LocalOffset,12)
	If $MFTReference = "FFFFFFFFFFFF" Then
		If $ScanMode < 1 Then Return SetError(1,0,0)
		$TextInformation &= ";MftRef"
	EndIf
	$MFTReference = Dec(_SwapEndian($MFTReference),2)
	If $MFTReference = 0 Then
		If $ScanMode < 1 Then Return SetError(1,0,0)
		$TextInformation &= ";MftRef"
	EndIf
	$MFTReferenceSeqNo = StringMid($InputData,$LocalOffset+12,4)
	$MFTReferenceSeqNo = Dec(_SwapEndian($MFTReferenceSeqNo),2)
	If $MFTReferenceSeqNo = 0 Then
		If $ScanMode < 1 Then Return SetError(2,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef"
		$TextInformation &= ";MftRefSeqNo"
	EndIf
	If $TextInformation = ";MftRef" Then $TextInformation &= ";MftRefSeqNo"
	$IndexEntryLength = StringMid($InputData,$LocalOffset+16,4)
	$IndexEntryLength = Dec(_SwapEndian($IndexEntryLength),2)
	If ($IndexEntryLength = 0) Or ($IndexEntryLength = 0xFFFF) Then
		If $ScanMode < 2 Then Return SetError(3,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo"
		$TextInformation &= ";IndexEntryLength"
	EndIf
	$OffsetToFileName = StringMid($InputData,$LocalOffset+20,4)
	$OffsetToFileName = Dec(_SwapEndian($OffsetToFileName),2)
	If ($OffsetToFileName = 0) Or ($OffsetToFileName = 0xFFFF) Then
		If $ScanMode < 2 Then Return SetError(4,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength"
		$TextInformation &= ";OffsetToFileName"
	EndIf

	$IndexFlags = StringMid($InputData,$LocalOffset+24,4)
	$IndexFlags = Dec(_SwapEndian($IndexFlags),2)
	If $IndexFlags > 2 Then
		If $ScanMode < 3 Then Return SetError(5,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName"
		$TextInformation &= ";IndexFlags"
	EndIf

	$Padding = StringMid($InputData,$LocalOffset+28,4)
	If $Padding <> "0000" Then
		If $ScanMode < 4 Then Return SetError(6,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags"
		$TextInformation &= ";Padding"
	EndIf
	$MFTReferenceOfParent = StringMid($InputData,$LocalOffset+32,12)
	$MFTReferenceOfParent = Dec(_SwapEndian($MFTReferenceOfParent),2)
	If $MFTReferenceOfParent < 5 Then
		If $ScanMode < 5 Then Return SetError(7,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding"
		$TextInformation &= ";MFTReferenceOfParent"
	EndIf
	$MFTReferenceOfParentSeqNo = StringMid($InputData,$LocalOffset+44,4)
	$MFTReferenceOfParentSeqNo = Dec(_SwapEndian($MFTReferenceOfParentSeqNo),2)
	If $MFTReferenceOfParentSeqNo = 0 Then
		If $ScanMode < 5 Then Return SetError(8,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding"
		$TextInformation &= ";MFTReferenceOfParentSeqNo"
	EndIf
	;CTime
	$Indx_CTime = StringMid($InputData, $LocalOffset + 48, 16)
	$Indx_CTime = _SwapEndian($Indx_CTime)
	If $ExtendedTimestampCheck Then
		$CTime_TimestampTmp = Dec($Indx_CTime,2)
		If $CTime_TimestampTmp < 112589990684262400 Or $CTime_TimestampTmp > 139611588448485376 Then ;14 oktober 1957 - 31 mai 2043
			If $ScanMode < 6 Then Return SetError(9,0,0)
			If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding;MFTReferenceOfParent;MFTReferenceOfParentSeqNo"
			$TextInformation &= ";CTime"
		EndIf
	EndIf
	$Indx_CTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $Indx_CTime)
	$Indx_CTime = _WinTime_UTCFileTimeFormat(Dec($Indx_CTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$Indx_CTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$Indx_CTime = $Indx_CTime & $PrecisionSeparator2 & _FillZero(StringRight($Indx_CTime_tmp, 4))
	EndIf
	If $Indx_CTime = $TimestampErrorVal Then
		If $ScanMode < 6 Then Return SetError(10,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding;MFTReferenceOfParent;MFTReferenceOfParentSeqNo"
		$TextInformation &= ";CTime"
	EndIf
	;ATime
	$Indx_ATime = StringMid($InputData, $LocalOffset + 64, 16)
	$Indx_ATime = _SwapEndian($Indx_ATime)
	If $ExtendedTimestampCheck Then
		$ATime_TimestampTmp = Dec($Indx_ATime,2)
		If $ATime_TimestampTmp < 112589990684262400 Or $ATime_TimestampTmp > 139611588448485376 Then ;14 oktober 1957 - 31 mai 2043
			If $ScanMode < 7 Then Return SetError(11,0,0)
			If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding;MFTReferenceOfParent;MFTReferenceOfParentSeqNo;CTime"
			$TextInformation &= ";ATime"
		EndIf
	EndIf
	$Indx_ATime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $Indx_ATime)
	$Indx_ATime = _WinTime_UTCFileTimeFormat(Dec($Indx_ATime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$Indx_ATime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$Indx_ATime = $Indx_ATime & $PrecisionSeparator2 & _FillZero(StringRight($Indx_ATime_tmp, 4))
	EndIf
	If $Indx_ATime = $TimestampErrorVal Then
		If $ScanMode < 7 Then Return SetError(12,0,0)
		If $TextInformation = "" Then $TextInformation &= ";MftRef;MftRefSeqNo;IndexEntryLength;OffsetToFileName;IndexFlags;Padding;MFTReferenceOfParent;MFTReferenceOfParentSeqNo;CTime"
		$TextInformation &= ";ATime"
	EndIf
	;MTime
	$Indx_MTime = StringMid($InputData, $LocalOffset + 80, 16)
	$Indx_MTime = _SwapEndian($Indx_MTime)
	If $ExtendedTimestampCheck Then
		$MTime_TimestampTmp = Dec($Indx_MTime,2)
		If $MTime_TimestampTmp < 112589990684262400 Or $MTime_TimestampTmp > 139611588448485376 Then ;14 oktober 1957 - 31 mai 2043
			If $ScanMode < 8 Then Return SetError(13,0,0)
			$TextInformation &= ";MTime"
		EndIf
	EndIf
	$Indx_MTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $Indx_MTime)
	$Indx_MTime = _WinTime_UTCFileTimeFormat(Dec($Indx_MTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$Indx_MTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$Indx_MTime = $Indx_MTime & $PrecisionSeparator2 & _FillZero(StringRight($Indx_MTime_tmp, 4))
	EndIf
	If $Indx_MTime = $TimestampErrorVal Then
		If $ScanMode < 8 Then Return SetError(14,0,0)
		$TextInformation &= ";MTime"
	EndIf
	;RTime
	$Indx_RTime = StringMid($InputData, $LocalOffset + 96, 16)
	$Indx_RTime = _SwapEndian($Indx_RTime)
	If $ExtendedTimestampCheck Then
		$RTime_TimestampTmp = Dec($Indx_RTime,2)
		If $RTime_TimestampTmp < 112589990684262400 Or $RTime_TimestampTmp > 139611588448485376 Then ;14 oktober 1957 - 31 mai 2043
			If $ScanMode < 9 Then Return SetError(15,0,0)
			$TextInformation &= ";RTime"
		EndIf
	EndIf
	$Indx_RTime_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $Indx_RTime)
	$Indx_RTime = _WinTime_UTCFileTimeFormat(Dec($Indx_RTime,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$Indx_RTime = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$Indx_RTime = $Indx_RTime & $PrecisionSeparator2 & _FillZero(StringRight($Indx_RTime_tmp, 4))
	EndIf
	If $Indx_RTime = $TimestampErrorVal Then
		If $ScanMode < 9 Then Return SetError(16,0,0)
		$TextInformation &= ";RTime"
	EndIf
	;
	$Indx_AllocSize = StringMid($InputData,$LocalOffset+112,16)
	$Indx_AllocSize = Dec(_SwapEndian($Indx_AllocSize),2)
	If $Indx_AllocSize > 281474976710655 Then ;0xFFFFFFFFFFFF
		If $ScanMode < 10 Then Return SetError(17,0,0)
		$TextInformation &= ";AllocSize"
	EndIf
	If $Indx_AllocSize > 0 And Mod($Indx_AllocSize,8) Then
		If $ScanMode < 10 Then Return SetError(17,0,0)
		$TextInformation &= ";AllocSize"
	EndIf
	$Indx_RealSize = StringMid($InputData,$LocalOffset+128,16)
	$Indx_RealSize = Dec(_SwapEndian($Indx_RealSize),2)
	If $Indx_RealSize > 281474976710655 Then ;0xFFFFFFFFFFFF
		If $ScanMode < 11 Then Return SetError(18,0,0)
		$TextInformation &= ";RealSize"
	EndIf
	If $Indx_RealSize > $Indx_AllocSize Then
		If $ScanMode < 11 Then Return SetError(18,0,0)
		$TextInformation &= ";RealSize"
	EndIf

	;-----------------------------------------------
	$Indx_File_Flags = StringMid($InputData,$LocalOffset+144,8)
	$Indx_File_Flags = _SwapEndian($Indx_File_Flags)

	If BitAND("0x" & $Indx_File_Flags, 0x40000) Then
		$DoReparseTag=0
		$DoEaSize=1
	Else
		$DoReparseTag=1
		$DoEaSize=0
	EndIf
	$Indx_File_Flags = _File_Attributes("0x" & $Indx_File_Flags)

	Select
		Case $DoReparseTag
			$Indx_EaSize = ""
			$Indx_ReparseTag = StringMid($InputData,$LocalOffset+152,8)
			$Indx_ReparseTag = _SwapEndian($Indx_ReparseTag)
			$Indx_ReparseTag = _GetReparseType("0x"&$Indx_ReparseTag)
			If StringInStr($Indx_ReparseTag,"UNKNOWN") Then
				If $ScanMode < 13 Then Return SetError(19,0,0)
				$TextInformation &= ";ReparseTag"
			EndIf
		Case $DoEaSize
			$Indx_ReparseTag = ""
			$Indx_EaSize = StringMid($InputData,$LocalOffset+152,8)
			$Indx_EaSize = Dec(_SwapEndian($Indx_EaSize),2)
			If $Indx_EaSize < 8 Then
				If $ScanMode < 13 Then Return SetError(19,0,0)
				$TextInformation &= ";EaSize"
			EndIf
	EndSelect
	;--------------------------------------------
	$Indx_NameLength = StringMid($InputData,$LocalOffset+160,2)
	$Indx_NameLength = Dec($Indx_NameLength)
	If $Indx_NameLength = 0 Then
		If $ScanMode < 14 Then Return SetError(20,0,0)
		$TextInformation &= ";NameLength"
	EndIf
	$Indx_NameSpace = StringMid($InputData,$LocalOffset+162,2)
	Select
		Case $Indx_NameSpace = "00"	;POSIX
			$Indx_NameSpace = "POSIX"
		Case $Indx_NameSpace = "01"	;WIN32
			$Indx_NameSpace = "WIN32"
		Case $Indx_NameSpace = "02"	;DOS
			$Indx_NameSpace = "DOS"
		Case $Indx_NameSpace = "03"	;DOS+WIN32
			$Indx_NameSpace = "DOS+WIN32"
		Case Else
			$Indx_NameSpace = "Unknown"
	EndSelect
	If $Indx_NameSpace = "Unknown" Then
		If $ScanMode < 14 Then Return SetError(21,0,0)
		$TextInformation &= ";NameSpace"
	EndIf

	$Indx_FileName = StringMid($InputData,165,$Indx_NameLength*4)
	$NameTest = 1
	Select
		Case $ExtendedNameCheckAll
;			_DumpOutput("$ExtendedNameCheckAll: " & $ExtendedNameCheckAll & @CRLF)
			$NameTest = _ValidateCharacterAndWindowsFileName($Indx_FileName)
		Case $ExtendedNameCheckChar
;			_DumpOutput("$ExtendedNameCheckChar: " & $ExtendedNameCheckChar & @CRLF)
			$NameTest = _ValidateCharacter($Indx_FileName)
		Case $ExtendedNameCheckWindows
;			_DumpOutput("$ExtendedNameCheckWindows: " & $ExtendedNameCheckWindows & @CRLF)
			$NameTest = _ValidateWindowsFileName($Indx_FileName)
	EndSelect
	If Not $NameTest Then
		If $ScanMode < 15 Then Return SetError(22,0,0)
		$TextInformation &= ";FileName"
	EndIf
	$Indx_FileName = BinaryToString("0x"&$Indx_FileName,2)
	If @error Or $Indx_FileName = "" Then
		If $ScanMode < 15 Then Return SetError(23,0,0)
		$TextInformation &= ";FileName"
	EndIf

	FileWriteLine($NewI30EntriesCsv, $RecordOffset & $de & $isSlack & $de & $Indx_FileName & $de & $MFTReference & $de & $MFTReferenceSeqNo & $de & $IndexFlags & $de & $MFTReferenceOfParent & $de & $MFTReferenceOfParentSeqNo & $de & $Indx_CTime & $de & $Indx_ATime & $de & $Indx_MTime & $de & $Indx_RTime & $de & $Indx_AllocSize & $de & $Indx_RealSize & $de & $Indx_File_Flags & $de & $Indx_ReparseTag & $de & $Indx_EaSize & $de & $Indx_NameSpace & $de & $TextInformation & @crlf)
	Return 1
EndFunc


Func _ValidateCharacter($InputString)
;ConsoleWrite("$InputString: " & $InputString & @CRLF)
	$StringLength = StringLen($InputString)
	For $i = 1 To $StringLength Step 4
		$TestChunk = StringMid($InputString,$i,4)
		$TestChunk = Dec(_SwapEndian($TestChunk),2)
		If ($TestChunk > 31 And $TestChunk < 256) Then
			ContinueLoop
		Else
			Return 0
		EndIf
	Next
	Return 1
EndFunc


Func _ValidateCharacterAndWindowsFileName($InputString)
;ConsoleWrite("$InputString: " & $InputString & @CRLF)
	$StringLength = StringLen($InputString)
	For $i = 1 To $StringLength Step 4
		$TestChunk = StringMid($InputString,$i,4)
		$TestChunk = Dec(_SwapEndian($TestChunk),2)
		If ($TestChunk > 31 And $TestChunk < 256) Then
			If ($TestChunk <> 47 And $TestChunk <> 92 And $TestChunk <> 58 And $TestChunk <> 42 And $TestChunk <> 63 And $TestChunk <> 34 And $TestChunk <> 60 And $TestChunk <> 62) Then
				ContinueLoop
			Else
				Return 0
			EndIf
			ContinueLoop
		Else
			Return 0
		EndIf
	Next
	Return 1
EndFunc

Func _DecodeTimestamp($StampDecode)
	$StampDecode = _SwapEndian($StampDecode)
	$StampDecode_tmp = _WinTime_UTCFileTimeToLocalFileTime("0x" & $StampDecode)
	$StampDecode = _WinTime_UTCFileTimeFormat(Dec($StampDecode,2) - $tDelta, $DateTimeFormat, $TimestampPrecision)
	If @error Then
		$StampDecode = $TimestampErrorVal
	ElseIf $TimestampPrecision = 3 Then
		$StampDecode = $StampDecode & $PrecisionSeparator2 & _FillZero(StringRight($StampDecode_tmp, 4))
	EndIf
	Return $StampDecode
EndFunc

Func _DisplayWrapper($sText)
	If $CommandlineMode Then
		ConsoleWrite($sText)
	Else
		_DisplayInfo($sText)
	EndIf
EndFunc

; ---- Create output --------

Func _WriteCSVHeaderRBI()
	$RBI_Csv_Header = "Offset"&$de&"MftRecordNumber"&$de&"FileName"&$de&"FileSize"&$de&"Timestamp"&$de&"TextInformation"
	FileWriteLine($RBICsv, $RBI_Csv_Header & @CRLF)
EndFunc

Func _WriteCSVHeaderI30Entries()
	$I30_Csv_Header = "Offset"&$de&"MftRecordNumber"&$de&"FileName"&$de&"MFTReference"&$de&"MFTReferenceSeqNo"&$de&"IndexFlags"&$de&"MFTParentReference"&$de&"MFTParentReferenceSeqNo"&$de&"CTime"&$de&"ATime"&$de&"MTime"&$de&"RTime"&$de&"AllocSize"&$de&"RealSize"&$de&"FileFlags"&$de&"ReparseTag"&$de&"NameSpace"&$de&"TextInformation"
	FileWriteLine($I30EntriesCsv, $I30_Csv_Header & @CRLF)
EndFunc

Func _WriteObjectIdCsvHeader()
	Local $CsvHeader = "MftRef"&$de&"MftRefSeqNo"&$de&"ObjectId"&$de&"ObjectId_Version"&$de&"ObjectId_Timestamp"&$de&"ObjectId_TimestampDec"&$de&"ObjectId_ClockSeq"&$de&"ObjectId_Node"&$de&"BirthVolumeId"&$de&"BirthVolumeId_Version"&$de&"BirthVolumeId_Timestamp"&$de&"BirthVolumeId_TimestampDec"&$de&"BirthVolumeId_ClockSeq"&$de&"BirthVolumeId_Node"&$de&"BirthObjectId"&$de&"BirthObjectId_Version"&$de&"BirthObjectId_Timestamp"&$de&"BirthObjectId_TimestampDec"&$de&"BirthObjectId_ClockSeq"&$de&"BirthObjectId_Node"&$de&"DomainId"&$de&"DomainId_Version"&$de&"DomainId_Timestamp"&$de&"DomainId_TimestampDec"&$de&"DomainId_ClockSeq"&$de&"DomainId_Node"
	FileWriteLine($EntriesObjectIdCsvFile, $CsvHeader & @CRLF)
EndFunc

Func _WriteReparsePointCsvHeader()
	Local $CsvHeader = "MftRef"&$de&"MftRefSeqNo"&$de&"ReparseType"&$de&"ReparseGuid"&$de&"ReparseData"&$de&"ReparseSubstititeName"&$de&"ReparsePrintName"
	FileWriteLine($ReparsePointCsvFile, $CsvHeader & @CRLF)
EndFunc

Func _WriteReparsePointAppExecLinkCsvHeader()
	Local $CsvHeader = "MftRef"&$de&"MftRefSeqNo"&$de&"Version"&$de&"PackageId"&$de&"EntryPoint"&$de&"Executable"&$de&"ApplicationType"
	FileWriteLine($ReparsePointAppExecLinkCsvFile, $CsvHeader & @CRLF)
EndFunc

Func _WriteEaCsvHeader()
	$Ea_Csv_Header = "MftRef"&$de&"MftRefSeqNo"&$de&"Counter"&$de&"EaFlags"&$de&"EaName"&$de&"EaValueLength"&$de&"EaValue"
	FileWriteLine($EaCsvFile, $Ea_Csv_Header & @CRLF)
EndFunc

Func _WriteTxfDataCsvHeader()
	$TxfData_Csv_Header = "MftRef"&$de&"MftRefSeqNo"&$de&"MftRef_RM_Root"&$de&"MftRefSeqNo_RM_Root"&$de&"UsnIndex"&$de&"TxfFileId"&$de&"LsnUserData"&$de&"LsnNtfsMetadata"&$de&"LsnDirectoryIndex"&$de&"UnknownFlag"
	FileWriteLine($LoggedUtilityStreamTxfDataCsvFile, $TxfData_Csv_Header & @CRLF)
EndFunc

Func _WriteLoggedUtilityStreamCsvHeader()
	$LoggedUtilityStream_Csv_Header = "MftRef"&$de&"MftRefSeqNo"&$de&"StreamName"&$de&"StreamSize"
	FileWriteLine($LoggedUtilityStreamCsvFile, $LoggedUtilityStream_Csv_Header & @CRLF)
EndFunc

Func _WriteCSVHeaderIndxEntries()
	$Indx_Csv_Header = "Offset"&$de&"FromSlack"&$de&"FileName"&$de&"MFTReference"&$de&"MFTReferenceSeqNo"&$de&"IndexFlags"&$de&"MFTParentReference"&$de&"MFTParentReferenceSeqNo"&$de&"CTime"&$de&"ATime"&$de&"MTime"&$de&"RTime"&$de&"AllocSize"&$de&"RealSize"&$de&"FileFlags"&$de&"ReparseTag"&$de&"EaSize"&$de&"NameSpace"&$de&"CorruptEntries"
	FileWriteLine($NewI30EntriesCsv, $Indx_Csv_Header & @CRLF)
EndFunc

Func _CreateOutputStructureAndFiles()

	; Output is already defined either explicitly or else default to current dir.

	Local $TimestampStart = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC

	$OutputPath = $OutputPath&"\Mft2Csv_"&$TimestampStart
	If DirCreate($OutputPath) = 0 Then
		ConsoleWrite("Error creating: " & $OutputPath & @CRLF)
		Exit
	EndIf

	$logfile = FileOpen($OutputPath & "\Mft_" & $TimestampStart & ".log",2+32)
	If @error Then
		ConsoleWrite("Error opening: " & $OutputPath & "\Mft_" & $TimestampStart & ".log" & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $OutputPath & "\Mft_" & $TimestampStart & ".log")
		Exit(1)
	EndIf
	_DebugOut("Operation started: " & $TimestampStart)

	$csvfile = $OutputPath & "\Mft_" & $TimestampStart & ".csv"
	$csv = FileOpen($csvfile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $csvfile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $csvfile)
		Exit(1)
	EndIf
	_WriteCSVHeader()

	$csvextra = $OutputPath & "\MftExtra_" & $TimestampStart & ".csv"
	If $DoSplitCsv Then _WriteCSVExtraHeader()

	$I30EntriesCsvFile = $OutputPath & "\Mft-Slack-I30-Entries_" & $TimestampStart & ".csv"
	$I30EntriesCsv = FileOpen($I30EntriesCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $I30EntriesCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $I30EntriesCsvFile)
		Exit(1)
	EndIf
	_WriteCSVHeaderI30Entries()

	$NewI30EntriesCsvFile = $OutputPath & "\Mft-All-I30-Entries_" & $TimestampStart & ".csv"
	$NewI30EntriesCsv = FileOpen($NewI30EntriesCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $NewI30EntriesCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $NewI30EntriesCsvFile)
		Exit(1)
	EndIf
	_WriteCSVHeaderIndxEntries()

	$RBICsvFile = $OutputPath & "\Mft-Slack-RBI_" & $TimestampStart & ".csv"
	$RBICsv = FileOpen($RBICsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $RBICsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $RBICsvFile)
		Exit(1)
	EndIf
	_WriteCSVHeaderRBI()

	;$OBJECT_ID
	$EntriesObjectIdCsvFile = $OutputPath & "\Mft-ObjectId-Entries_" & $TimestampStart & ".csv"
	$EntriesObjectIdCsv = FileOpen($EntriesObjectIdCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $EntriesObjectIdCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $EntriesObjectIdCsvFile)
		Exit(1)
	EndIf
	_WriteObjectIdCsvHeader()

	;$REPARSE_POINT
	$ReparsePointCsvFile = $OutputPath & "\Mft-ReparsePoint-Entries_" & $TimestampStart & ".csv"
	$ReparsePointCsv = FileOpen($ReparsePointCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $ReparsePointCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $ReparsePointCsvFile)
		Exit(1)
	EndIf
	_WriteReparsePointCsvHeader()

	;$REPARSE_POINT -> AppExecLink type
	$ReparsePointAppExecLinkCsvFile = $OutputPath & "\Mft-ReparsePoint-AppExecLink_" & $TimestampStart & ".csv"
	$ReparsePointAppExecLinkCsv = FileOpen($ReparsePointAppExecLinkCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $ReparsePointAppExecLinkCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $ReparsePointAppExecLinkCsvFile)
		Exit(1)
	EndIf
	_WriteReparsePointAppExecLinkCsvHeader()

	;$EA
	$EaCsvFile = $OutputPath & "\Mft-Ea-Entries_" & $TimestampStart & ".csv"
	$EaCsv = FileOpen($EaCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $EaCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $EaCsvFile)
		Exit(1)
	EndIf
	_WriteEaCsvHeader()

	;$LOGGED_UTILITY_STREAM
	$LoggedUtilityStreamCsvFile = $OutputPath & "\Mft-LOGGED_UTILITY_STREAM_" & $TimestampStart & ".csv"
	$LoggedUtilityStreamCsv = FileOpen($LoggedUtilityStreamCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $LoggedUtilityStreamCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $LoggedUtilityStreamCsvFile)
		Exit(1)
	EndIf
	_WriteLoggedUtilityStreamCsvHeader()

	;$LOGGED_UTILITY_STREAM:$TXF_DATA
	$LoggedUtilityStreamTxfDataCsvFile = $OutputPath & "\Mft-TXF_DATA_" & $TimestampStart & ".csv"
	$LoggedUtilityStreamTxfDataCsv = FileOpen($LoggedUtilityStreamTxfDataCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $LoggedUtilityStreamTxfDataCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $LoggedUtilityStreamTxfDataCsvFile)
		Exit(1)
	EndIf
	_WriteTxfDataCsvHeader()

	;$DATA
	$AdditionalDataCsvFile = $OutputPath & "\Mft-DATA_" & $TimestampStart & ".csv"
	$AdditionalDataCsv = FileOpen($AdditionalDataCsvFile, $EncodingWhenOpen)
	If @error Then
		ConsoleWrite("Error opening: " & $AdditionalDataCsvFile & @CRLF)
		MsgBox(0, "Error", "Error opening: " & $AdditionalDataCsvFile)
		Exit(1)
	EndIf
	_WriteCSVHeaderAdditionalData()

	; sql stuff

	Local $MftSqlFile = $OutputPath & "\Mft_" & $TimestampStart & ".sql"
	FileInstall(".\import-sql\import-csv-mft.sql", $MftSqlFile)
	Local $FixedPath = StringReplace($csvfile, "\", "\\")
	Sleep(500)
	_ReplaceStringInFile($MftSqlFile, "__PathToCsv__", $FixedPath)
	If $CheckUnicode = 1 Then _ReplaceStringInFile($MftSqlFile, "latin1", "utf8")

	Local $MftCarvedI30SqlFile = $OutputPath & "\Mft-Slack-I30-Entries_" & $TimestampStart & ".sql"
	FileInstall(".\import-sql\import-csv-mft-carved-i30.sql", $MftCarvedI30SqlFile)
	$FixedPath = StringReplace($I30EntriesCsvFile, "\", "\\")
	Sleep(500)
	_ReplaceStringInFile($MftCarvedI30SqlFile, "__PathToCsv__", $FixedPath)
	If $CheckUnicode = 1 Then _ReplaceStringInFile($MftCarvedI30SqlFile, "latin1", "utf8")

	Local $MftAllI30SqlFile = $OutputPath & "\Mft-All-I30-Entries_" & $TimestampStart & ".sql"
	FileInstall(".\import-sql\import-csv-mft-I30-all.sql", $MftAllI30SqlFile)
	$FixedPath = StringReplace($NewI30EntriesCsvFile, "\", "\\")
	Sleep(500)
	_ReplaceStringInFile($MftAllI30SqlFile, "__PathToCsv__", $FixedPath)
	If $CheckUnicode = 1 Then _ReplaceStringInFile($MftAllI30SqlFile, "latin1", "utf8")

	Local $MftObjectIdSqlFile = $OutputPath & "\Mft-ObjectId-Entries_" & $TimestampStart & ".sql"
	FileInstall(".\import-sql\import-csv-mft-objectid.sql", $MftObjectIdSqlFile)
	$FixedPath = StringReplace($EntriesObjectIdCsvFile, "\", "\\")
	Sleep(500)
	_ReplaceStringInFile($MftObjectIdSqlFile, "__PathToCsv__", $FixedPath)
	If $CheckUnicode = 1 Then _ReplaceStringInFile($MftObjectIdSqlFile, "latin1", "utf8")

EndFunc

; ---- /Create output --------
