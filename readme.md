# Get currency rate in XML.   

## Description  
This package gets ***XML*** rate from http://pf-soft.net and insert into table.   
It's insert row only when rate is changed.  
It runs with job (here).   
Get rate (without insert  into table):
```sh
declare
  r_set_date date;
  r_rate number;
begin
   currency_xml.read_from_pfsoft(to_date('06.12.2050','DD.MM.YYYY'), r_set_date, r_rate);
   dbms_output.put_line( to_char(r_set_date,'DD.MM.YYYY')||' - '||to_char(r_rate)  );
end;
```
## Note   
Data in request and data in XML body are different data.

----------------------------------------------------------------

# Отримати курс валют в XML форматі.
## Опис
Пакет отримує ***XML*** курс з http://pf-soft.net і вставляє в таблицю.
Вставляється тільки тоді коли курс змінився.
Запускається через Job.  
Отримати курс (без вставки в таблицю)  
```sh
declare
  r_set_date date;
  r_rate number;
begin
   currency_xml.read_from_pfsoft(to_date('06.12.2050','DD.MM.YYYY'), r_set_date, r_rate);
   dbms_output.put_line( to_char(r_set_date,'DD.MM.YYYY')||' - '||to_char(r_rate)  );
end;
```
## Note   
Дата в запиті і дата в тілі XML можуть відрізнятися.  
