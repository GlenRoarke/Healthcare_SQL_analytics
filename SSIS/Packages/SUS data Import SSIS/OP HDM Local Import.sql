--OP HDM_Local Import to OP_PBR_CCGs

select --[Local Patient Identifier]
--,[NHS Number]
[Attendance Identifier]
--Practice 
,[PCT Derived from GP Practice] [PDS_PracticeCCG]
,[Commissioner Code (Original Data)] [PAS_PracticeCCG]
,[GP Practice Code (Derived)] [PDS_PracticeCode]
,[GP Practice Code (Original Data)] [PAS_PracticeCode]
,[GP Practice Derived from PDS]
--Postcode
,[Patient Postcode Derived PCT] [PDS_PostcodeCCG]
,[PCT of Residence (Original)] [PAS_PostcodeCCG]
,[Patient Postcode Derived PCT Type]
,[Organisation Code (PCT of Residence)]
,[Postcode of Usual Address]
,cast([Tariff Total Payment National] as int)[Tariff Total Payment National]
from SUS_Data.dbo.tmp_OP_SUS
where ([GP Practice Code (Derived)] <> [GP Practice Code (Original Data)])
or ([Patient Postcode Derived PCT] <> [PCT of Residence (Original)])


