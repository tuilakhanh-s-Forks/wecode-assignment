CREATE DATABASE QLGOTO

USE QLGOTO

CREATE TABLE OXE (
	MAO VARCHAR(4) PRIMARY KEY,
	TANG VARCHAR(2),
	TOANHA VARCHAR(2),
	DAI FLOAT,
	RONG FLOAT,
	CAO FLOAT,
	TTHAI VARCHAR(15),
	HTSAC VARCHAR(10),
	GIA MONEY
)

CREATE TABLE KHACHHANG (
	MAKH VARCHAR(5) PRIMARY KEY,
	TENKH VARCHAR(50),
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NGDK SMALLDATETIME,
)

CREATE TABLE XE 
(
	MAXE VARCHAR(4) PRIMARY KEY,
	BIENSO VARCHAR(15),
	MAKH VARCHAR(5) FOREIGN KEY REFERENCES KHACHHANG(MAKH),
	HANGXE VARCHAR(10),
	LOAIXE VARCHAR(10),
	TENXE VARCHAR(10),
	DAI FLOAT,
	RONG FLOAT,
	CAO FLOAT,
)

CREATE TABLE GUIXE 
(
	MAGUI VARCHAR(4),
	MAXE VARCHAR(4) FOREIGN KEY REFERENCES XE(MAXE),
	MAO VARCHAR(4) FOREIGN KEY REFERENCES OXE(MAO),
	TGBD DATETIME,
	TGKT DATETIME,
	TONGTIEN MONEY
)

SET DATEFORMAT dmy

INSERT INTO OXE (MAO , TANG , TOANHA , DAI , RONG , CAO , TTHAI , HTSAC , GIA) VALUES ('O001 ', 'B1 ', 'C1 ', '5.2', '2', '2', 'dang   bao tri', 'khong ', '60')
INSERT INTO OXE (MAO , TANG , TOANHA , DAI , RONG , CAO , TTHAI , HTSAC , GIA) VALUES ('O002 ', 'B2 ', 'G1 ', '5.5', '2.5', '1.8', 'trong ', 'co ', '100')
INSERT INTO OXE (MAO , TANG , TOANHA , DAI , RONG , CAO , TTHAI , HTSAC , GIA) VALUES ('O003 ', 'B3 ', 'G2 ', '5.2', '2', '2', 'trong ', 'khong ', '60')


INSERT INTO KHACHHANG (MAKH , TENKH , NGSINH , GIOITINH , NGDK) VALUES ('KH001 ', 'Tran Tuyet Nhi ', '12/09/1999 ', 'Nu ', '15/06/2020')
INSERT INTO KHACHHANG (MAKH , TENKH , NGSINH , GIOITINH , NGDK) VALUES ('KH002 ', 'Ngo Tuan Phong ', '13/09/1991 ', 'Nam ', '17/02/2020')
INSERT INTO KHACHHANG (MAKH , TENKH , NGSINH , GIOITINH , NGDK) VALUES ('KH003 ', 'Nguyen Manh Linh ', '17/05/1992 ', 'Nam ', '18/03/2021')

INSERT INTO XE (MAXE , BIENSO , MAKH , HANGXE , LOAIXE, TENXE, DAI , RONG , CAO) VALUES ('X001 ', '14-Y3   132.25', 'KH001 ', 'KIA ', 'dien ', 'Ioniq   5', '4.635', '1.89', '1.605')
INSERT INTO XE (MAXE , BIENSO , MAKH , HANGXE , LOAIXE, TENXE, DAI , RONG , CAO) VALUES ('X002 ', '12A 111.08 ', 'KH002 ', 'BMW ', 'xang ', 'X3 ', '4.708', '1.891', '1.676')
INSERT INTO XE (MAXE , BIENSO , MAKH , HANGXE , LOAIXE, TENXE, DAI , RONG , CAO) VALUES ('X003 ', '49-T1   012.05', 'KH003 ', 'Toyota ', 'xang ', 'Cross ', '4.4', '1.825', '1.62')

INSERT INTO GUIXE (MAGUI , MAXE , MAO , TGBD , TGKT , TONGTIEN) VALUES ('G001 ', 'X001 ', 'O002 ', '22/02/2022 11:16:00', '23/02/2022 11:10:00', '100')
INSERT INTO GUIXE (MAGUI , MAXE , MAO , TGBD , TGKT , TONGTIEN) VALUES ('G002 ', 'X002 ', 'O003 ', '15/03/2022 12:16:00', '16/03/2022 12:05:00', '60')
INSERT INTO GUIXE (MAGUI , MAXE , MAO , TGBD , TGKT , TONGTIEN) VALUES ('G003 ', 'X003 ', 'O003 ', '17/03/2022 12:16:00', '19/03/2022 12:16:00', '120')

-- Cau 3
CREATE TRIGGER i_u_oxe ON OXE
FOR INSERT, UPDATE 
AS 
BEGIN
	IF EXISTS (SELECT *
				FROM INSERTED i
				WHERE i.TOANHA = 'C1' AND i.HTSAC = 'co')
		BEGIN 
			PRINT 'ERROR'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN 
			PRINT 'THEM, SUA THANH CONG' 
		END
	
END


-- Cau 4
CREATE TRIGGER i_u_guixe ON GUIXE
FOR INSERT, UPDATE
AS BEGIN 
	IF EXISTS (SELECT *
				FROM INSERTED i
				JOIN OXE o ON i.MAO = o.MAO
				JOIN XE x ON i.MAXE = x.MAXE
				WHERE x.DAI > o.DAI * 0.9 AND x.RONG > o.RONG * 0.9 AND x.CAO > o.CAO * 0.9 AND o.HTSAC = 'co')
		BEGIN 
			PRINT 'ERROR'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN 
			PRINT 'THEM, SUA THANH CONG' 
		END
END

CREATE TRIGGER i_u_xe ON XE
FOR INSERT, UPDATE
AS BEGIN 
	IF EXISTS (SELECT *
				FROM INSERTED i
				JOIN OXE o ON i.MAO = o.MAO
				JOIN GUIXE g ON g.MAXE = i.MAXE
				WHERE i.DAI > o.DAI * 0.9 AND i.RONG > o.RONG * 0.9 AND i.CAO > o.CAO * 0.9 AND o.HTSAC = 'co')
		BEGIN 
			PRINT 'ERROR'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN 
			PRINT 'THEM, SUA THANH CONG' 
		END
END

CREATE TRIGGER i_u_oxe ON OXE
FOR INSERT, UPDATE
AS BEGIN 
	IF EXISTS (SELECT *
				FROM INSERTED i
				JOIN GUIXE g ON g.MAXE = i.MAXE
				JOIN XE x ON x.MAXE = g.MAXE 
				WHERE x.DAI > i.DAI * 0.9 AND x.RONG > i.RONG * 0.9 AND x.CAO > i.CAO * 0.9 AND i.HTSAC = 'co')
		BEGIN 
			PRINT 'ERROR'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN 
			PRINT 'THEM, SUA THANH CONG' 
		END
END

-- Cau 5
SELECT x.BIENSO, x.TENXE 
FROM XE x 
JOIN GUIXE g
ON x.MAXE = g.MAXE 
JOIN KHACHHANG k 
ON k.MAKH = x.MAKH 
WHERE x.LOAIXE = 'xang' AND x.HANGXE = 'KIA' AND k.MAKH = 'Nu' AND MONTH(g.TGBD) = 3 AND YEAR(g.TGBD) = 2022
ORDER BY g.TGBD 

-- Cau 6
SELECT TOP 1 WITH TIES o.TOANHA
FROM GUIXE g 
JOIN XE x ON g.MAXE = x.MAXE 
JOIN OXE o ON g.MAO = o.MAO 
WHERE x.HANGXE = 'KIA' AND MONTH(g.TGBD) = 6 AND YEAR(g.TGBD) = 2022
GROUP BY o.TOANHA 
ORDER BY COUNT(*) DESC

-- Cau 7
SELECT DISTINCT x.TENXE  
FROM XE x 
WHERE x.HANGXE = 'Toyota' AND x.LOAIXE = 'dien' AND NOT EXISTS (
	SELECT *
	FROM GUIXE g 
	JOIN OXE o ON g.MAO = o.MAO 
	WHERE o.TOANHA = 'G2' AND g.MAXE = x.MAXE 
)

-- Cau 8
SELECT k.MAKH k.TENKH 
FROM KHACHHANG k 
JOIN XE x ON k.MAKH = x.MAKH 
WHERE NOT EXISTS (
	SELECT *
	FROM OXE o 
	WHERE o.HTSAC = 'co' AND NOT EXISTS (
		SELECT *
		FROM GUIXE g 
		WHERE g.MAO = o.MAO AND g.MAXE = x.MAXE 
	)
)

