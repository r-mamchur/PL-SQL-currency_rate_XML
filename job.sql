
DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'currency_xml.currency_set(sysdate);'
   ,next_date => to_date('04.12.2019 12:00:00','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'TRUNC(SYSDATE+1)+12/24'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/