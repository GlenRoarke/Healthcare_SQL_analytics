/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [SUS Version]
      ,[NHS RID (From Provider)]
      ,[Spell Identifier]
      ,[Parent Spell Identifier]
      ,[Generated Record ID]
      ,[Dominant Generated Record ID]
      ,[First Generated Record ID]
      ,[Last Generated Record ID]
      ,[CDS Record Type]
      ,[Reason Access Provided]
      ,[CDS Group Derived]
      ,[CDS Group Indicator]
      ,[Bulk Replacement CDS Group]
      ,[Pseudonymised Status]
      ,[Confidentiality Category]
      ,[Local Patient Identifier]
      ,[Org Code Local Patient Identifier]
      ,[NHS Number]
      ,[NHS Number (Mother)]
      ,[Lead Care Activity Indicator]
      ,[Organisation Code Patient Pathway Identifier]
      ,[RTT Patient Pathway Identifier]
      ,[RTT Period End Date]
      ,[RTT Period Start Date]
      ,[RTT Status]
      ,[Unique Booking Reference Number (Converted)]
      ,[RTT Length (Derived)]
      ,convert(date,[Birth Date],20) [Birth Date]
      ,[Age At CDS Activity Date]
      ,[Patient Type]
      ,[Age at Start of Episode Derived]
      ,[Age At Start of Spell]
      ,[Spell Age]
      ,[Episode Age]
      ,[Local Patient Identifier (Mother)]
      ,[Org Code Local Patient Identifier (Mother)]
      ,convert(date,[Birth Date (Mother)],20) [Birth Date (Mother)]
      ,[Year of Birth]
      ,[Birth Year (Mother)]
      ,[Birth Month]
      ,[Birth Month (Mother)]
      ,[Age at Spell End Original]
      ,[Age at Record Start]
      ,[Age At End of Spell]
      ,[Age at Spell Start Original]
      ,[Age at Record End]
      ,[Age Range Derived]
      ,[Age Range Derived (Mother)]
      ,[Carer Support Indicator]
      ,[Legal Status Classification Code]
      ,[Ethnic Category Code]
      ,[Marital Status]
      ,[NHS Number Status Indicator]
      ,[Gender Code]
      ,[Total Previous Pregnancies]
      ,[Postcode of Usual Address]
      ,[Postcode Sector of Usual Address]
      ,[Organisation Code (PCT of Residence)]
      ,[Patient Postcode Derived PCT Type]
      ,[Patient Postcode Derived PCT]
      ,[Patient Name]
      ,[Patient Usual Address]
      ,[Organisation Code Type PCT of Residence]
      ,[NHS Number Status Indicator (Mother)]
      ,[Postcode Dominant]
      ,[Patient Usual Address (Mother)]
      ,[Postcode of Usual Address (Mother)]
      ,[Area Code of Usual Address]
      ,[Area Code Derived]
      ,[Organisation Code (PCT of Residence - Mother)]
      ,[Patient Postcode Derived PCT Type (Mother)]
      ,[Patient Postcode Electoral Ward]
      ,[SHA from Patient Postcode]
      ,[SHA Type from Patient Postcode]
      ,[Census Output Area 2001]
      ,[Country]
      ,[County Code]
      ,[ED County Code]
      ,[ED District Code]
      ,[Electoral Ward Division]
      ,[Government Office Region Code]
      ,[Local Authority Code]
      ,[SHA Old Org Code]
      ,[Electoral Ward 1998]
      ,[Hospital Provider Spell No]
      ,[ADMINISTRATIVE CATEGORY (AT START OF EPISODE)]
      ,[ADMINISTRATIVE CATEGORY (ON ADMISSION)]
      ,[Patient Classification]
      ,[Admission Method (Hospital Provider Spell)]
      ,[Admission Method (Original Data)]
      ,[Admission Type (Derived)]
      ,[Admission Subtype (Derived)]
      ,[Discharge Destination (Hospital Provider Spell)]
      ,[Discharge Method (Hospital Provider Spell)]
      ,[Source of Admission (Hospital Provider Spell)]
      ,convert(date,[Start Date (Hospital Provider Spell)],20) [Start Date (Hospital Provider Spell)]
      ,convert(date,[End Date (Hospital Provider Spell)],20) [End Date (Hospital Provider Spell)]
      ,[Spell In PbR Not In PbR]
      ,[Spell Version As At Date And Time]
      ,[Delay Discharge Reason]
      ,[Delayed Discharged Days]
      ,[Administrative Category (Derived)]
      ,[Elective Admission Type]
      ,convert(date,[PbR Spell Start Date],20) [PbR Spell Start Date]
      ,convert(date,[PbR Spell End Date],20) [PbR Spell End Date]
      ,convert(date,[Hospital Provider Spell Discharge Date],20) [Hospital Provider Spell Discharge Date]
      ,convert(date,[Hospital Provider Spell End Date],20) [Hospital Provider Spell End Date]
      ,[Ready for Discharge Date]
      ,[PbR Delayed Discharge Days Derived]
      ,[Spell Exclusion Reason]
      ,[Applicable Costing Period]
      ,[Episode Number]
      ,[First Regular Day Night Admission]
      ,[Last Episode in Spell Indicator]
      ,[Neonatal Level of Care]
      ,[Operation Status]
      ,convert(date,[Episode Start Date],20) [Episode Start Date]
      ,convert(date,[Episode End Date],20) [Episode End Date]
      ,convert(date,[CDS Activity Date],20) [CDS Activity Date]
      ,[Episode Start Date Original]
      ,[Commissioner Serial No (Agreement No)]
      ,[NHS Service Agreement Line No]
      ,[Provider Reference No]
      ,[Commissioner Reference No]
      ,[SHA Commissioner]
      ,[SHA Provider]
      ,[Organisation Code (Code of Provider)]
      ,[Provider Site Code]
      ,[Organisation Code (Code of Commissioner)]
      ,[Commissioner Code (Original Data)]
      ,[Commissioner Site Code]
      ,[Spell Commissioner Code]
      ,[PCT Derived from GP]
      ,[PCT Derived from GP Practice]
      ,[GP Practice Derived from PDS]
      ,[Site code of Treatment (at start of episode)]
      ,[Organisation Code Type Provider]
      ,[Provider Code (Original Data)]
      ,[Provider Location Derived]
      ,[Organisation Code Type Commissioner]
      ,[GP PCT Type (Derived)]
      ,[SHA from GP (Derived)]
      ,[SHA Type from GP (Derived)]
      ,[PCT Derived from GP Practice (Mother)]
      ,[Consultant Code]
      ,[Main Specialty Code]
      ,[Treatment Function Code]
      ,[Consultant Code Type]
      ,[Consultant Organisation Code]
      ,[Organisation Code Type Consultant]
      ,[Specialty Function Code Original]
      ,[Elective Consultant Code]
      ,[Elective Consultant Specialty Code]
      ,[Elective Consultant Code Type]
      ,[Elective Specialty Function Code]
      ,[Elective Consultant Organisation Code]
      ,[Organisation Code Type Elective Consultant]
      ,[Antenatal Consultant Code]
      ,[Antenatal Consultant Specialty Code]
      ,[Antenatal Consultant Code Type]
      ,[Antenatal Specialty Function Code]
      ,[Antenatal Consultant Organisation Code]
      ,[Organisation Code Type Antenatal Consultant]
      ,[Registered GMP Code]
      ,[GP Code (Original data)]
      ,[GP Practice Code]
      ,[GP Consortium Code]
      ,[GP Practice Code (Original Data)]
      ,[GP Practice Code (Derived)]
      ,[Referrer Code]
      ,[Referring Organisation Code]
      ,[Code of GP]
      ,[Organisation Code GP]
      ,[Organisation Code Type GP]
      ,[Organisation Code Type GP Practice]
      ,[GP Code (Mother)]
      ,[Organisation Code GP (Mother)]
      ,[Organisation Code Type GP (Mother)]
      ,[GP Code Type]
      ,[GP Code Type (Mother)]
      ,[First GP Organisation Code]
      ,[GP Practice Code Original]
      ,[GP Practice Code Derived]
      ,[GP Practice Code derived (Mother)]
      ,[Organisation Code Type Referrer]
      ,[Referrer Code Type]
      ,[Organisation Code Type Prime Recipient]
      ,[Duration of Elective Wait]
      ,[Intended Management]
      ,[Decided To Admit Date]
      ,[Episode Duration]
      ,[Episode Duration Grouper]
      ,[Length of Stay (Hospital Provider Spell)]
      ,[PbR NCC PCC Adjusted Length of Stay]
      ,[PbR Final Adjusted Length of Stay]
      ,[Spell ACC Length Of Stay]
      ,[Spell NCC Length Of Stay]
      ,[Spell PCC Length Of Stay]
      ,[Spell Primary Diagnosis]
      ,[Spell Secondary Diagnosis]
      ,[HRG Submitted]
      ,[HRG Version (Submitted)]
      ,[Core HRG (Calculated)]
      ,[Episode HRG Version (Calculated)]
      ,[Episode Dominant Procedure]
      ,[Grouping Algorithm Version]
      ,[Grouping Reference Data Version]
      ,[Grouping HRG Version]
      ,[Spell Core HRG]
      ,[HRG Dominant Grouping Variable]
      ,[HRG Procedure Scheme]
      ,[Unbundled HRG 1]
      ,[Unbundled HRG 2]
      ,[Unbundled HRG 3]
      ,[Unbundled HRG 4]
      ,[Unbundled HRG 5]
      ,[Unbundled HRG 6]
      ,[Unbundled HRG 7]
      ,[Unbundled HRG 8]
      ,[Unbundled HRG 9]
      ,[Unbundled HRG 10]
      ,[Unbundled HRG 11]
      ,[Unbundled HRG 12]
      ,[Programme Budgeting Category]
      ,[Spell Programme Budgeting Category]
      ,[Spell Report Flag]
      ,[PbR Excluded Indicator]
      ,[Episode Exclusion Reason]
      ,[Code Cleaning]
      ,[PbR Costed Indicator]
      ,[Grouping Method]
      ,[Configurable Indicator]
      ,[Diagnosis Scheme In Use]
      ,[Primary Diagnosis Code]
      ,[Secondary Diagnosis Code 1]
      ,[Secondary Diagnosis Code 2]
      ,[Secondary Diagnosis Code 3]
      ,[Secondary Diagnosis Code 4]
      ,[Secondary Diagnosis Code 5]
      ,[Secondary Diagnosis Code 6]
      ,[Secondary Diagnosis Code 7]
      ,[Secondary Diagnosis Code 8]
      ,[Secondary Diagnosis Code 9]
      ,[Secondary Diagnosis Code 10]
      ,[Secondary Diagnosis Code 11]
      ,[Secondary Diagnosis Code 12]
      ,[Procedure Scheme In Use]
      ,[Primary Procedure Code]
      ,[Primary Procedure Date]
      ,[Secondary Procedure Code 1]
      ,[Secondary Procedure Date 1]
      ,[Secondary Procedure Code 2]
      ,[Secondary Procedure Date 2]
      ,[Secondary Procedure Code 3]
      ,[Secondary Procedure Date 3]
      ,[Secondary Procedure Code 4]
      ,[Secondary Procedure Date 4]
      ,[Secondary Procedure Code 5]
      ,[Secondary Procedure Date 5]
      ,[Secondary Procedure Code 6]
      ,[Secondary Procedure Date 6]
      ,[Secondary Procedure Code 7]
      ,[Secondary Procedure Date 7]
      ,[Secondary Procedure Code 8]
      ,[Secondary Procedure Date 8]
      ,[Secondary Procedure Code 9]
      ,[Secondary Procedure Date 9]
      ,[Secondary Procedure Code 10]
      ,[Secondary Procedure Date 10]
      ,[Secondary Procedure Code 11]
      ,[Secondary Procedure Date 11]
      ,[Secondary Procedure Code 12]
      ,[Secondary Procedure Date 12]
      ,[Spell Dominant Procedure]
      ,[Advanced Cardiovascular Support Days]
      ,[Advanced Respiratory Support Days]
      ,[Basic Cardiovascular Support Days]
      ,[Basic Respiratory Support Days]
      ,[Critical Care Level 2 Days]
      ,[Critical Care Level 3 Days]
      ,[Critical Care Unit Function]
      ,[Dermatological Support Days]
      ,[Neurological Support Days]
      ,[Renal Support Days]
      ,[Liver Support Days]
      ,[Episode ACC Length Of Stay]
      ,[Episode NCC Length Of Stay]
      ,[Episode PCC Length Of Stay]
      ,[APC Tariff ID]
      ,[Market Forces Factor]
      ,[Market Forces Factor ID]
      ,[Tariff Initial Amount National]
      ,[Tariff Day Case National]
      ,[Tariff Long Stay Payment National]
      ,[Tariff Long Stay Rate National]
      ,[Tariff Service Adjustment National]
      ,[Tariff Short Stay Elective National]
      ,[Tariff Short Stay Emergency National]
      ,[Aggregate UnBundled Adjustment National]
      ,[Tariff Financial Adjustment National]
      ,[Tariff Adjustment Future Use_1 National]
      ,[Tariff Adjustment Future Use_2 National]
      ,[Applied MFF Elective]
      ,[Applied MFF Non Elective]
      ,[MFF Adjustment]
      ,[Tariff Pre MFF Adjusted National]
      ,[Tariff Total Payment National]
      ,[Tariff Initial Amount Non Mandatory]
      ,[Tariff Day Case Non Mandatory]
      ,[Tariff Short Stay Emergency Non Mandatory]
      ,[Tariff Spec Serv Adjustment Non Mandatory]
      ,[Tariff Long Stay Rate Non Mandatory]
      ,[Tariff Long Stay Payment Non Mandatory]
      ,[Aggregate UnBundled Adjustment Non Mandatory]
      ,[Tariff Financial Adjustment Non Mandatory]
      ,[Tariff Adjustment Future Use_1 Non Mandatory]
      ,[Tariff Adjustment Future Use_2 Non Mandatory]
      ,[Applied MFF Elective Non Mandatory]
      ,[Applied MFF Non Elective Non Mandatory]
      ,[Tariff Pre MFF Adjusted Non Mandatory]
      ,[Tariff Total Payment Non Mandatory]
      ,[Non Mandatory Core Tariff (with UB)]
      ,[Optional APC BPT Adjustment]
      ,[Tarrif Initial Amount Local]
      ,[Tariff Day Case Local]
      ,[Tariff Short Stay Emergency Local]
      ,[Tariff Long Stay Rate Local]
      ,[Aggregate UnBundled Adjustment Local]
      ,[Tariff Long Stay Payment Local]
      ,[Tariff Total Payment Local]
      ,[Local Core Tariff (with UB)]
      ,[PbR Final Tariff]
      ,[Final Tariff Applied]
      ,[App Period Spell Status Indicator]
      ,[Hospital Provider Spell Duration Days Derived]
      ,[Number of Episodes in PbR Spell]
      ,[RAP DH Tariff Adjustment Child]
      ,[RAP Validation Child Indicator]
      ,[RAP Spell Type]
      ,[PbR Generated Interchange ID]
      ,[PbR Spell Cost ID]
      ,[PbR Spell Cost Version Date]
      ,[PbR Spell Const Version Number]
      ,[PbR Spell Complete Indicator]
      ,[PbR Spell Error Status]
      ,[PbR Spell Frozen Indicator]
      ,[Spell Service ID]
      ,[Spell Service Version]
      ,[PbR Spell Status Indicator]
      ,[Match Criterion Indicator]
      ,[Number of Babies]
      ,[Location Class of Delivery Place (Intended)]
      ,[Location Type of Delivery Place (Intended)]
      ,[Anaesthetic During Labour]
      ,[Anaesthetic Post Labour]
      ,[Location Class of Delivery Place (Actual)]
      ,[Location Type of Delivery Place (Actual)]
      ,[Birth Order]
      ,[Birth Weight]
      ,convert(date,[Delivery Date],20) [Delivery Date]
      ,[Delivery Method]
      ,[Delivery Place Change Reason]
      ,[Delivery Place Type Actual]
      ,[Delivery Place Type Intended]
      ,convert(date,[First Antenatal Assessment Date],20) [First Antenatal Assessment Date]
      ,[Gestation Length]
      ,[Gestation Length Assessment]
      ,[Live or Still Birth]
      ,[Status of Person Conducting Delivery]
      ,[Local Patient Identifier (Baby)]
      ,[Org Code Local Patient Identifier (Baby)]
      ,[NHS Number (Baby)]
      ,[NHS Number Status Ind (Baby)]
      ,convert(date,[Date of Birth (Baby)],20) [Date of Birth (Baby)]
      ,[Sex (Baby)]
      ,[Costing Batch Sequence]
      ,[Count of Days Suspended]
      ,[Current Period Number]
      ,[PbR Days Beyond Trimpoint]
      ,[PbR Spell Trimpoint Days]
      ,[Significant Specialised Service Code]
      ,[Specialised Service Code 1]
      ,[Specialised Service Code 2]
      ,[Specialised Service Code 3]
      ,[Specialised Service Code 4]
      ,[Specialised Service Code 5]
      ,[BPT Indicator 1]
      ,[BPT Indicator 1 Action]
      ,[BPT Indicator 2]
      ,[BPT Indicator 2 Action]
      ,[BPT Indicator 3]
      ,[BPT Indicator 3 Action]
      ,[BPT Indicator 4]
      ,[BPT Indicator 4 Action]
      ,[BPT Indicator 5]
      ,[BPT Indicator 5 Action]
      ,[Dominant Contract Identifier]
      ,[Episode Duration Days Derived]
      ,[Error Reason]
      ,[Excluded Critical Care Days]
      ,[Finished Indicator]
      ,[First Attendance]
      ,[First Staging Loaded Date]
      ,[HES Identifier]
      ,[Hierarchy]
      ,[Intended Procedure Status]
      ,[Interchange ID]
      ,[Last Did Not Arrive Date]
      ,[Last Entry Review Date]
      ,[Last Staging Loaded Date]
      ,[Location Type Code]
      ,[Logically Deleted Date]
      ,[Maximum Episode Date]
      ,[Onset Method]
      ,[Organisation Code Type Location]
      ,[Other Indicator]
      ,[Outcome Of Attendance]
      ,[PCT Responsible]
      ,[Record Extraction Indicator]
      ,[Re-costing Requested Flag]
      ,[Resuscitation Method]
      ,[Service Original]
      ,[Service Top-up Percentage]
      ,[Short Stay Redn Pcnt]
      ,[Significant Service ID]
      ,[Specialty Service Top-up]
      ,[Temporary Cost Period Status]
      ,[Test Indicator]
      ,[Update Type]
      ,[Version Sequence Number]
      ,[Number of Commissioners in PbR Spell]
      ,[Number Diagnosis]
      ,[Number Procedures]
      ,[Number Unbundled HRGs]
      ,[Number Unbundled Non Priced HRGs]
      ,[Number Unbundled Priced HRGs]
      ,[Excluded Episodes in Hospital Provider Spell]
      ,[Number Hospital Provider Spell ID]
      ,[Number SSCs]
      ,[Number BPT Indicators]
      ,[Organisation Code (Sender)]
      ,[Staging Loaded Date]
      ,[Protocol Identifier]
      ,[Unique CDS Identifier]
      ,[Applicable Date]
      ,convert(date,[Extract Date],20) [Extract Date]
      ,convert(date,[Report Period Start Date],20) [Report Period Start Date]
      ,convert(date,[Report Period End Date],20) [Report Period End Date]
      ,[Organisation Code Type Sender]
      ,convert(date,[Dominant Staging Loaded Date],20) [Dominant Staging Loaded Date]
      ,[Extract Type]
      ,[Location Class at Epistart]
      ,[Org Code Location at Epistart]
      ,[Org Code Type Location at Epistart]
      ,[Intended Care Intensity at Epistart]
      ,[Age Group Intended at Epistart]
      ,[Sex Of Patients at Epistart]
      ,[Day Period Availability at Epistart]
      ,[Night Period Availability at Epistart]
      ,[Location Class at Epiend]
      ,[Org Code Location at Epiend]
      ,[Org Code Type Location at Epiend]
      ,[Intended Care Intensity at Epiend]
      ,[Age Group Intended at Epiend]
      ,[Sex Of Patients at Epiend]
      ,[Day Period Availability at Epiend]
      ,[Night Period Availability at Epiend]
      ,[Spare 1]
      ,[Spare 2]
      ,[Spare 3]
      ,[Spare 4]
      ,[Spare 5]
      ,[FCE NPOC]
      ,[FCE Service Line]
      ,[FCE Service Line List]
      ,[Spell NPOC]
      ,[Spell Service Line]
      ,[Commissioning Region]
      ,[Data Quality Indicator]
      ,[Unbundled exclusion reason]
      ,[CDS Schema Version]
      ,[Query Date]
      ,[Unique Query Id]
      ,[Prime Recipient]
      ,[Copy Recipients]
      ,[Ward Code at Episode Start Date]
      ,[Ward Security Level at Episode Start Date]
      ,[Ward Code at Episode End Date]
      ,[Ward Security Level at Episode End Date]
      ,[Derived Commissioner]
      ,[Derived Commissioner Type]
      ,[Open Spell Indicator]
      ,[NHSE Planning Commissioner]
      ,[Evidence Based Intervention Category]
      ,[Evidence Based Intervention Type]
  FROM [SUS_Data].[dbo].[IP_SUS_Rec_Staging]