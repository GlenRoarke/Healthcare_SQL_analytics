SELECT a.DIM_HCP_ID
,HCP_FORENAME
,HCP_SURNAME
,a.HCP_MAIN_CODE
,SPECIALTY
,SPEC_NHS_CODE
,a.START_DTTM
,a.END_DTTM
,SPEC_MAIN_FLAG
,a.Create_DTTM
,a.MODIF_DTTM
,a.ARCHV_FLAG
,b.HCP_LOCAL_CODE

 FROM [HDM].[dbo].[DIM_HC_PROFESSIONAL_SPECIALTY] a
 INNER JOIN [HDM].[dbo].[DIM_HC_PROFESSIONAL] b on a.DIM_HCP_ID = b.DIM_HCP_ID
  where  SPEC_NHS_CODE not in ( '100','101','110','120','130','140','141','142','143','145','146','147','148'
,'149','150','160','170','171','180','190','192','300','301','302','303','304','305','310','311','313'
,'314','315','320','321','325','326','330','340','350','352','360','361','370','371','400','401','410'
,'420','421','430','450','451','460','500','501','502','504','560','600','601','700','710','711','712'
,'713','715','800','810','820','821','822','823','824','830','831','833','834','900','901','902','903'
,'904','950','960')
and SPEC_NHS_CODE <> 'Unkn'
and HCP_FORENAME <> 'Unknown'
and SPEC_MAIN_FLAG <>'N'
and a.ARCHV_FLAG = 'N'
and a.DIM_HCP_ID <> 3935 --odd record that has no activity against it GR 07/08/2019


--These are Western consultant codes added for the Merging project, the are invalid specialties
and a.DIM_HCP_ID not in ('143204','163087','163144','163155','163170','163184','163196','163250','163243','163268','163300','163357','163355','163416')


select * from [dbo].[DIM_HC_PROFESSIONAL] WHERE [DIM_HCP_ID] IN (
SELECT DIM_HCP_ID

 FROM [HDM].[dbo].[DIM_HC_PROFESSIONAL_SPECIALTY]
  where  SPEC_NHS_CODE not in ( '100','101','110','120','130','140','141','142','143','145','146','147','148'
,'149','150','160','170','171','180','190','192','300','301','302','303','304','305','310','311','313'
,'314','315','320','321','325','326','330','340','350','352','360','361','370','371','400','401','410'
,'420','421','430','450','451','460','500','501','502','504','560','600','601','700','710','711','712'
,'713','715','800','810','820','821','822','823','824','830','831','833','834','900','901','902','903'
,'904','950','960')
and SPEC_NHS_CODE <> 'Unkn'
and HCP_FORENAME <> 'Unknown'
and SPEC_MAIN_FLAG <>'N'
and ARCHV_FLAG = 'N'
and DIM_HCP_ID <> 3935) --odd record that has no activity against it GR 07/08/2019