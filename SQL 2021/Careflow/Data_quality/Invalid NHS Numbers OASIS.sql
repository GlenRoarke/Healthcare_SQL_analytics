select pm.PATIENT_ID, pm.status, ID_NUMBER,
case  when LENGTH(ID_NUMBER)= 10 then 
    case when (
        Case when
                       11- mod((SUBSTR(pi.ID_NUMBER,1,1)*10+
                        SUBSTR(pi.ID_NUMBER,2,1)*9+
                        SUBSTR(pi.ID_NUMBER,3,1)*8+
                        SUBSTR(pi.ID_NUMBER,4,1)*7+
                        SUBSTR(pi.ID_NUMBER,5,1)*6+
                        SUBSTR(pi.ID_NUMBER,6,1)*5+
                        SUBSTR(pi.ID_NUMBER,7,1)*4+
                        SUBSTR(pi.ID_NUMBER,8,1)*3+
                        SUBSTR(pi.ID_NUMBER,9,1)*2),11)=11
                        then 0 else (
                                         11- mod((SUBSTR(pi.ID_NUMBER,1,1)*10+
                                        SUBSTR(pi.ID_NUMBER,2,1)*9+
                                        SUBSTR(pi.ID_NUMBER,3,1)*8+
                                        SUBSTR(pi.ID_NUMBER,4,1)*7+
                                        SUBSTR(pi.ID_NUMBER,5,1)*6+
                                        SUBSTR(pi.ID_NUMBER,6,1)*5+
                                        SUBSTR(pi.ID_NUMBER,7,1)*4+
                                        SUBSTR(pi.ID_NUMBER,8,1)*3+
                                        SUBSTR(pi.ID_NUMBER,9,1)*2),11)) end ) =SUBSTR(pi.ID_NUMBER,10,1)*1 then 1 else 0 end
 else 0 end  as "v"
from patient_master pm
left join patient_IDS pi on pm.PATIENT_ID = pi.PATIENT_ID
where pi.ID_TYPE_CODE = 56970
and ID_NUMBER <> '.'
