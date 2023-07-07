-- Updates Treatment Site Code in CDS for IS activity -14/03/2022 YY
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NW603' WHERE [Provider_Reference_Number]  = 'NW603'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT364' WHERE [Provider_Reference_Number]  = 'NT364'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT205' WHERE [Provider_Reference_Number]  = 'NT205'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT218' WHERE [Provider_Reference_Number]  = 'NT218'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NW601' WHERE [Provider_Reference_Number]  = 'NW601'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'I9A4A' WHERE [Provider_Reference_Number]  = 'I9A4A'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NV7R1' WHERE [Provider_Reference_Number]  = 'NV7R1'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT310' WHERE [Provider_Reference_Number]  = 'NT310'

-- Updates Treatemnt sitecode for IS OP activity
UPDATE HDM_CDS.CDS.OP SET SITE_CODE_OF_TREATMENT = 'I9A4A' WHERE [PROVIDER_REFERENCE_NUMBER] = 'I9A4A'
UPDATE HDM_CDS.CDS.OP SET SITE_CODE_OF_TREATMENT = 'NT364' WHERE [PROVIDER_REFERENCE_NUMBER] = 'NT364'
UPDATE HDM_CDS.CDS.OP  SET SITE_CODE_OF_TREATMENT = 'NT218' WHERE [PROVIDER_REFERENCE_NUMBER] = 'NT218'


select [PROVIDER_REFERENCE_NUMBER], SITE_CODE_OF_TREATMENT FROM HDM_CDS.CDS.OP  group by  [PROVIDER_REFERENCE_NUMBER], SITE_CODE_OF_TREATMENT

SELECT * FROM [Contracting].[DIM_CONTRACT_LINE] ORDER BY CREATE_DTTM asc


select * from HDM_CDS.CDS.APC WHERE [Provider_Reference_Number] IN ('NW603'
,'NT364'
,'NT205'
,'NT218'
,'NW601'
,'I9A4A'
,'I9A4A'
,'NV7R1'
,'NT310')

select [Provider_Reference_Number],count(1) FROM HDM_CDS.CDS.APC GROUP BY  [Provider_Reference_Number]


select Organisation_Code_Patient_ID_Mother FROM HDM_CDS.CDS.APC ORDER BY 1 desc
