CREATE OR REPLACE PACKAGE body currency_xml IS

   -- встановити курс на задану дату
  PROCEDURE currency_set (p_request_date in date)
  is
    r_set_date  date;
    r_rate  number;
    r_str varchar2(1024):='';
  begin
    read_from_pfsoft(p_request_date => p_request_date,
                     p_set_date => r_set_date,
                     p_rate => r_rate );

	select max(to_char(start_action_date,'YYYYMMDD')||to_char(rate))
	     into r_str from currency_rates where start_action_date <= r_set_date;

        -- конструкцiя to_date(substr(r_str,9),'YYYYMMDD')<>r_set_date про всяк випадок,
	-- якщо за цю дату курс вже є, але вiдрiзняється
	-- збiй типу r_set_date=null проiгнорується
	IF to_date(substr(r_str,1,8),'YYYYMMDD')<>r_set_date and to_number(substr(r_str,9))<>r_rate Then
	   insert into currency_rates ( CURRENCY_CODE, START_ACTION_DATE,RATE) values ('USD',r_set_date,r_rate);
           Insert Into log_all(module_label, dt, importance, txt)
              Values('Currency_xml',sysdate, 1, 'Внесено курс валют на '||to_char(r_set_date,'DD.MM.YYYY') );
	Else
	   dbmsout('не заносим','N');
           Insert Into log_all(module_label, dt, importance, txt)
              Values('Currency_xml',sysdate, 1, 'НЕвнесено курс валют, pfsoft на '||to_char(r_set_date,'DD.MM.YYYY') );
	End if;
    Commit;

  End currency_set;

  -- отримати на певну дату, дата встановлення курсу може вiдрiзнятися вiд дати запиту
 PROCEDURE read_from_pfsoft(p_request_date in date, p_set_date out date, p_rate out number)
 is
    url        VARCHAR2(256);
    req        utl_http.req;
    resp       utl_http.resp;
    r_success  BOOLEAN;
    name       VARCHAR2(256);
    value      VARCHAR2(10240);
    r_str      varchar2(10240):='';
    r_xml      XMLType;
    r_xml_usd  XMLType;
    i          integer;
    tmp_msg       varchar2(250);
    err_code      integer;
    err_text      varchar2(2000);

  BEGIN
    p_set_date:=null;
    p_rate:=0;
    url:='http://pf-soft.net/service/currency/?date='||to_char(p_request_date,'DDMMYYYY');
    req := utl_http.begin_request(url);
    resp := utl_http.get_response(req);
    r_success := resp.status_code = 200;
    IF not r_success THEN
       utl_http.end_response(resp);
       Insert Into log_all(module_label, dt, importance, txt)
            Values('Currency_xml',sysdate, 10, 'Немає доступу '||to_char(p_request_date,'DD.MM.YYYY') 
               ||' status - '||to_char(resp.status_code)
               ||' reason_phrase - '||resp.reason_phrase );
       Commit;
       Return;
    End If;
    -- Шапка HTTP
    FOR i IN 1 .. utl_http.get_header_count(resp)
    LOOP utl_http.get_header(resp, i, name, value);
       r_success := name = 'Content-Type' AND value like 'text/xml%';
    EXIT WHEN r_success;
    END LOOP;
    
    IF not r_success THEN
       utl_http.end_response(resp);
       Insert Into log_all(module_label, dt, importance, txt)
            Values('Currency_xml',sysdate, 10, 'Помилка в шапцi '||to_char(p_request_date,'DD.MM.YYYY')||'  '||name ||'-'||value);
       Commit;
       Return;
    End if;
    -- Збираєм XML
    BEGIN
      LOOP utl_http.read_line(resp, value, TRUE);
           r_str := r_str || nvl(value,' ');
      END LOOP;
    EXCEPTION
      -- тут закриється i вподальшому закривати непотрiбно
      WHEN utl_http.end_of_body THEN
         utl_http.end_response(resp);
      When OTHERS THEN
         utl_http.end_response(resp);
         err_code:=sqlcode;
         err_text:=sqlerrm;
         tmp_msg:='body http ERROR EXCEPTION (код '||to_char(err_code)||'): '||
               CHR(10)||err_text;
         Insert into log_all(module_label, dt, importance, error_code, txt)
             Values('Currency_xml', sysdate, 10, err_code, tmp_msg);
         Commit;
    END;

    r_xml:=xmltype(r_str);    -- наш результат

    r_str:=r_xml.extract('/ValCurs/@SetDate').getstringval();
    p_set_date := to_date(r_str,'DD/MM/YYYY');

    r_xml_usd:=r_xml.EXTRACT('/ValCurs/Valute[./CharCode="USD"]');
     --  mожна
     -- r_xml_usd:=r_xml.EXTRACT('/ValCurs/Valute[CharCode="USD"]');

    p_rate := r_xml_usd.extract('/Valute/Value/text()').getnumberval() /
              r_xml_usd.extract('/Valute/Nominal/text()').getnumberval();

  EXCEPTION When OTHERS THEN
     utl_http.end_response(resp);
     err_code:=sqlcode;
     err_text:=sqlerrm;
     tmp_msg:='ERROR EXCEPTION (код '||to_char(err_code)||'): '||
             CHR(10)||err_text;
     Insert into log_all(module_label, dt, importance, error_code, txt)
             Values('Currency_xml', sysdate, 10, err_code, tmp_msg);
     Commit;
  END read_from_pfsoft;
END currency_xml;
/

