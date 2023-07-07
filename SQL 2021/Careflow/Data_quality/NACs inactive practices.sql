select HCO_NAME,HCO_NHS_CODE, HCO_ACTIVE_FLAG, HCO_PROTECTED_FLAG from hdm.dbo.DIM_HC_Organisation  

where  create_dttm  between '29/04/2021' and '30/04/2021'
and HCO_TYPE = 'General Medical Practice'

and HCO_ACTIVE_FLAG = 'N'

hco_main_code = 'H82029'