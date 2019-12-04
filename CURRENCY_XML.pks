CREATE OR REPLACE PACKAGE BIL_ADMIN.currency_xml IS

-- встановити курс на задану дату
  PROCEDURE currency_set (p_request_date in date);

-- з pfsoft
-- отримати на певну дату, дата встановлення валюти може вiдрiзнятися вiд дати запиту
 PROCEDURE read_from_pfsoft(p_request_date in date, p_set_date out date, p_rate out number);

END currency_xml;
/

