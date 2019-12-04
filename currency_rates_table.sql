CREATE TABLE CURRENCY_RATES
(
  CURRENCY_CODE      VARCHAR2(3 BYTE)           NOT NULL,
  START_ACTION_DATE  DATE                       NOT NULL,
  RATE               NUMBER(12,4)
);

COMMENT ON TABLE CURRENCY_RATES IS 'Довідник курсів валют';

COMMENT ON COLUMN CURRENCY_RATES.CURRENCY_CODE IS 'Код валюти';

COMMENT ON COLUMN CURRENCY_RATES.START_ACTION_DATE IS 'Дата, з якої починає діяти встановлений курс валюти';

COMMENT ON COLUMN CURRENCY_RATES.RATE IS 'Курс валюти по відношенню до гривні';
