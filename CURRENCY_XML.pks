CREATE OR REPLACE PACKAGE BIL_ADMIN.currency_xml IS

-- ���������� ���� �� ������ ����
  PROCEDURE currency_set (p_request_date in date);

-- � pfsoft
-- �������� �� ����� ����, ���� ������������ ������ ���� �i��i������� �i� ���� ������
 PROCEDURE read_from_pfsoft(p_request_date in date, p_set_date out date, p_rate out number);

END currency_xml;
/

