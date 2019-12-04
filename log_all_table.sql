CREATE TABLE LOG_ALL
(
  MODULE_LABEL  VARCHAR2(50 BYTE),
  RECORD_ID     INTEGER,
  DT            DATE                            DEFAULT sysdate,
  PROCESS_ID    INTEGER                         DEFAULT userenv('sessionid'),
  IMPORTANCE    INTEGER,
  ERROR_CODE    INTEGER,
  TXT           VARCHAR2(2000 BYTE),
  CREATED_BY    VARCHAR2(30 BYTE)               DEFAULT User,
  CREATED_DATE  DATE                            DEFAULT Sysdate
);

COMMENT ON TABLE LOG_ALL IS 'Протокол виконання дій';

COMMENT ON COLUMN LOG_ALL.MODULE_LABEL IS 'Умовне позначення виконуваного програмного модулю';

COMMENT ON COLUMN LOG_ALL.RECORD_ID IS 'Порядковий номер запису у протоколі';

COMMENT ON COLUMN LOG_ALL.DT IS 'Дата запису';

COMMENT ON COLUMN LOG_ALL.PROCESS_ID IS 'Системний ідентифікатор процесу Oracle';

COMMENT ON COLUMN LOG_ALL.IMPORTANCE IS 'Рівень важливості запису';

COMMENT ON COLUMN LOG_ALL.ERROR_CODE IS 'Код програмної помилки (тільки для записів про помилки, для інших пустий)';

COMMENT ON COLUMN LOG_ALL.TXT IS 'Текст запису';

COMMENT ON COLUMN LOG_ALL.CREATED_BY IS 'Дата створення запису';

COMMENT ON COLUMN LOG_ALL.CREATED_DATE IS 'Користувач, що створив запис';


CREATE OR REPLACE TRIGGER LOG_ALL_INSERT
BEFORE INSERT
ON LOG_ALL REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  SELECT seq_log_record_id.NEXTVAL
    INTO :NEW.record_id
    FROM dual;
END;
/

