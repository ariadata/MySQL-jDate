--		Jalali (j) and Georgian (g) Date in MySQL and MariaDB By Neo! Team of AriaData [Mehrdad Amini]
--		Replace `homa` with Your DataBase Username

/* Function __neo_div is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_div`;
DELIMITER ;;
	CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_div`(`a` int, `b` int) RETURNS bigint(20)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
	return FLOOR(a / b);
END;;
DELIMITER ;

/* Function __neo_mod is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_mod`;
DELIMITER ;;
	CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_mod`(`a` int, `b` int) RETURNS bigint(20)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
	return (a - b * FLOOR(a / b));
	END;;
DELIMITER ;

/* Function __neo_g is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_g`;
DELIMITER ;;
	CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_g`(`m` smallint) RETURNS smallint(2)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
	CASE m
		WHEN 0 THEN RETURN 31;
		WHEN 1 THEN RETURN 28;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 30;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 30;
		WHEN 6 THEN RETURN 31;
		WHEN 7 THEN RETURN 31;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 31;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 31;
	END CASE;
	END;;
DELIMITER ;

/* Function __neo_g2 is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_g2`;
	DELIMITER ;;
	CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_g2`(`m` smallint, `k` SMALLINT) RETURNS smallint(2)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
		CASE m
			WHEN 0 THEN RETURN 31;
			WHEN 1 THEN RETURN 28+k;
			WHEN 2 THEN RETURN 31;
			WHEN 3 THEN RETURN 30;
			WHEN 4 THEN RETURN 31;
			WHEN 5 THEN RETURN 30;
			WHEN 6 THEN RETURN 31;
			WHEN 7 THEN RETURN 31;
			WHEN 8 THEN RETURN 30;
			WHEN 9 THEN RETURN 31;
			WHEN 10 THEN RETURN 30;
			WHEN 11 THEN RETURN 31;
		END CASE;
	END;;
DELIMITER ;

/* Function __neo_j is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_j`;
DELIMITER ;;
	CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_j`(`m` smallint) RETURNS smallint(2)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
	CASE m
		WHEN 0 THEN RETURN 31;
		WHEN 1 THEN RETURN 31;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 31;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 31;
		WHEN 6 THEN RETURN 30;
		WHEN 7 THEN RETURN 30;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 30;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 29;
	END CASE;
	END;;
DELIMITER ;

/* Function __neo_j2 is for Using in Other Functions */
DROP FUNCTION IF EXISTS `__neo_j2`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `__neo_j2`(`m` smallint) RETURNS smallint(2)
BEGIN
	CASE m
		WHEN 1 THEN RETURN 31;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 31;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 31;
		WHEN 6 THEN RETURN 31;
		WHEN 7 THEN RETURN 30;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 30;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 30;
		WHEN 12 THEN RETURN 29;
	END CASE;
END;;
DELIMITER ;

/* Function jdate Input is Georgian DateTime output is Y-m-d H:i:s format in Jalali */
DROP FUNCTION IF EXISTS `jdate`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `jdate`(`gdate` datetime) RETURNS char(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE i, gy, gm, gd, g_day_no, j_day_no, j_np, jy, jm, jd INT DEFAULT 0;
	DECLARE resout char(100);
	DECLARE ttime CHAR(20);
	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET ttime = TIME(gdate);
	SET g_day_no = ((365 * gy) + __neo_div(gy + 3, 4) - __neo_div(gy + 99, 100) + __neo_div (gy + 399, 400));
	SET i = 0;
	WHILE (i < gm) do
		SET g_day_no = g_day_no + __neo_g(i);
		SET i = i + 1;
	END WHILE;
	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN SET g_day_no =	g_day_no + 1; END IF;
	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	SET j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __neo_div(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;
	IF j_day_no >= 366 then SET jy = jy + __neo_div(j_day_no - 1, 365); SET j_day_no = (j_day_no - 1) % 365; END IF;
	SET i = 0;
	WHILE (i < 11 and j_day_no >= __neo_j(i)) do
		SET j_day_no = j_day_no - __neo_j(i);
		SET i = i + 1;
	END WHILE;
	SET jm = i + 1;
	SET jd = j_day_no + 1;
	SET resout = CONCAT_WS ('-', jy, jm, jd);
	IF (ttime <> '00:00:00') then SET resout = CONCAT_WS(' ', resout, ttime); END IF;
	RETURN resout;
END;;
DELIMITER ;

/* Function jyear Input is Georgian Date and output is Jalali Year Y format */
DROP FUNCTION IF EXISTS `jyear`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `jyear`(`gdate` datetime) RETURNS char(100) CHARSET utf8
BEGIN
	DECLARE	i, gy, gm, gd, g_day_no, j_day_no, j_np, jy, jm, jd INT DEFAULT 0;
	DECLARE resout char(100);
	DECLARE ttime CHAR(20);
	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET ttime = TIME(gdate);
	SET g_day_no = ((365 * gy) + __neo_div(gy + 3, 4) - __neo_div(gy + 99, 100) + __neo_div(gy + 399, 400));
	SET i = 0;
	WHILE (i < gm) do
		SET g_day_no = g_day_no + __neo_g(i);
		SET i = i + 1;
	END WHILE;
	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN SET g_day_no =	g_day_no + 1; END IF;
	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	set j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __neo_div(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;
	IF j_day_no >= 366 then
		SET jy = jy + __neo_div(j_day_no - 1, 365);
		SET j_day_no = (j_day_no - 1) % 365;
	END IF;
	SET i = 0;
	WHILE (i < 11 and j_day_no >= __neo_j(i)) do
		SET j_day_no = j_day_no - __neo_j(i);
		SET i = i + 1;
	END WHILE;
	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jy;
END;;
DELIMITER ;

/* Function jmonth Input is Georgian Date and output is Jalali Month m format */
DROP FUNCTION IF EXISTS `jmonth`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `jmonth`(`gdate` datetime) RETURNS char(100) CHARSET utf8
BEGIN
	DECLARE i, gy, gm, gd, g_day_no, j_day_no, j_np, jy, jm, jd INT DEFAULT 0;
	DECLARE resout char(100);
	DECLARE ttime CHAR(20);
	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET ttime = TIME(gdate);
	SET g_day_no = ((365 * gy) + __neo_div(gy + 3, 4) - __neo_div(gy + 99, 100) + __neo_div(gy + 399, 400));
	SET i = 0;
	WHILE (i < gm) do
		SET g_day_no = g_day_no + __neo_g(i);
		SET i = i + 1; 
	END WHILE;
	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN SET g_day_no = g_day_no + 1; END IF;
	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	set j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __neo_div(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;
	IF j_day_no >= 366 then 
		SET jy = jy + __neo_div(j_day_no - 1, 365);
		SET j_day_no =(j_day_no - 1) % 365;
	END IF;
	SET i = 0;
	WHILE (i < 11 and j_day_no >= __neo_j(i)) do
		SET j_day_no = j_day_no - __neo_j(i);
		SET i = i + 1;
	END WHILE;
	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jm;
END;;
DELIMITER ;

/* Function jday Input is Georgian Date and output is Jalali Day d format */
DROP FUNCTION IF EXISTS `jday`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `jday`(`gdate` datetime) RETURNS char(100) CHARSET utf8
BEGIN
	DECLARE	i, gy, gm, gd, g_day_no, j_day_no, j_np, jy, jm, jd INT DEFAULT 0;
	DECLARE resout char(100);
	DECLARE ttime CHAR(20);
	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET ttime = TIME(gdate);
	SET g_day_no = ((365 * gy) + __neo_div(gy + 3, 4) - __neo_div(gy + 99 , 100) + __neo_div(gy + 399, 400));
	SET i = 0;
	WHILE (i < gm) do
		SET g_day_no = g_day_no + __neo_g(i);
		SET i = i + 1;
	END WHILE;
	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN SET g_day_no = g_day_no + 1; END IF;
	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	SET j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __neo_div(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;
	IF j_day_no >= 366 then
		SET jy = jy + __neo_div(j_day_no - 1, 365);
		SET j_day_no = (j_day_no-1) % 365;
	END IF;
	SET i = 0;
	WHILE (i < 11 and j_day_no >= __neo_j(i)) do
		SET j_day_no = j_day_no - __neo_j(i);
		SET i = i + 1;
	END WHILE;
	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jd;
END;;
DELIMITER ;

/* Function gdate Input is ("Y","m","d") in Jalali Format like ("1397","12","21") and output is Georgian Datetime in Y-m-d */
DROP FUNCTION IF EXISTS `gdate`;
DELIMITER ;;
CREATE DEFINER=`homa`@`localhost` FUNCTION `gdate`(`jy` smallint, `jm` smallint, `jd` smallint) RETURNS datetime
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE	i, j, e, k, mo, gy, gm, gd, g_day_no, j_day_no, bkab, jmm, mday, g_day_mo, bkab1, j1 INT DEFAULT 0;
	DECLARE resout char(100);
	DECLARE fdate datetime;
	SET bkab = __neo_mod(jy,33);
	IF (bkab = 1 or bkab= 5 or bkab = 9 or bkab = 13 or bkab = 17 or bkab = 22 or bkab = 26 or bkab = 30) THEN SET j=1; end IF;
	SET bkab1 = __neo_mod(jy+1,33);
	IF (bkab1 = 1 or bkab1= 5 or bkab1 = 9 or bkab1 = 13 or bkab1 = 17 or bkab1 = 22 or bkab1 = 26 or bkab1 = 30) THEN SET j1=1; end IF;
	CASE jm
		WHEN 1 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 2 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 3 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 4 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 5 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 6 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 7 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 8 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 9 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 10 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 11 THEN IF jd > __neo_j2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 12 THEN IF jd > __neo_j2(jm)+j or jd <= 0 THEN SET e=1; end IF;
	END CASE;
	IF jm > 12 or jm <= 0 THEN SET e=1; end IF;
	IF jy <= 0 THEN SET e=1; end IF;
	IF e>0 THEN RETURN 0; end IF;
	IF (jm>=11) or (jm=10 and jd>=11 and j=0) or (jm=10 and jd>11 and j=1) THEN SET i=1; end IF;
	SET gy = jy + 621 + i;
	IF (__neo_mod(gy,4)=0) THEN SET k=1; end IF;
	IF (__neo_mod(gy,100)=0) and (__neo_mod(gy,400)<>0) THEN SET k=0; END IF;
	SET jmm=jm-1;
	WHILE (jmm > 0) do
		SET mday=mday+__neo_j2(jmm);
		SET jmm=jmm-1;
	end WHILE;
	SET j_day_no=(jy-1)*365+(__neo_div(jy,4))+mday+jd;
	SET g_day_no=j_day_no+226899;
	SET g_day_no=g_day_no-(__neo_div(gy-1,4));
	SET g_day_mo=__neo_mod(g_day_no,365);
	IF (k=1 and j=1) THEN
		IF (g_day_mo=0) THEN RETURN CONCAT_WS('-',gy,'12','30'); END IF;
		IF (g_day_mo=1) THEN RETURN CONCAT_WS('-',gy,'12','31'); END IF;
	END IF;
	IF (g_day_mo=0) THEN RETURN CONCAT_WS('-',gy,'12','31'); END IF;
	SET mo=0;
	SET gm=gm+1;
	while g_day_mo>__neo_g2(mo,k) do
	SET g_day_mo=g_day_mo-__neo_g2(mo,k);
    SET mo=mo+1;
    SET gm=gm+1;
	end WHILE;
	SET gd=g_day_mo;
	RETURN CONCAT_WS('-',gy,gm,gd);
END;;
DELIMITER ;