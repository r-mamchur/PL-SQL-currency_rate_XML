CREATE TABLE CURRENCY_RATES
(
  CURRENCY_CODE      VARCHAR2(3 BYTE)           NOT NULL,
  START_ACTION_DATE  DATE                       NOT NULL,
  RATE               NUMBER(12,4)
);

COMMENT ON TABLE CURRENCY_RATES IS '������� ����� �����';

COMMENT ON COLUMN CURRENCY_RATES.CURRENCY_CODE IS '��� ������';

COMMENT ON COLUMN CURRENCY_RATES.START_ACTION_DATE IS '����, � ��� ������ ���� ������������ ���� ������';

COMMENT ON COLUMN CURRENCY_RATES.RATE IS '���� ������ �� ��������� �� �����';
