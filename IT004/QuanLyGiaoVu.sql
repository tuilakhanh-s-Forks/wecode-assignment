CREATE DATABASE QLGV

USE QLGV

CREATE TABLE KHOA
(
	MAKHOA varchar(4) PRIMARY KEY,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4) 
)

CREATE TABLE MONHOC
(
	MAMH varchar(10) PRIMARY KEY,
	TENMH varchar(40),
	TCLT tinyint,
	TCTH tinyint,
	MAKHOA varchar(4)
)

CREATE TABLE DIEUKIEN
(
	MAMH varchar(10) FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	MAMH_TRUOC varchar(10) FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY(MAMH, MAMH_TRUOC)
)

CREATE TABLE GIAOVIEN 
(	
	MAGV char(4) PRIMARY KEY,
	HOTEN varchar(40),
	HOCVI varchar(10),
	HOCHAM varchar(10),
	GIOITINH varchar(3),
	NGSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric(4,2),
	MUCLUONG money,
	MAKHOA varchar(4)
)

CREATE TABLE LOP
(
	MALOP char(3) PRIMARY KEY,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4)
)

CREATE TABLE HOCVIEN
(
	MAHV char(5) PRIMARY KEY,
	HO varchar(40),
	TEN varchar(10),
	NGSINH smalldatetime,
	GIOITINH varchar(3),
	NOISINH varchar(40),
	MALOP char(3)
)

CREATE TABLE GIANGDAY
(
	MALOP char(3) FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
	MAMH varchar(10) FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	MAGV char(4),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime,
	CONSTRAINT PK_GIANGDAY PRIMARY KEY(MALOP, MAMH)
)

CREATE TABLE KETQUATHI
(
	MAHV char(5) FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
	MAMH varchar(10) FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	LANTHI tinyint,
	NGTHI smalldatetime,
	DIEM numeric(4,2),
	KQUA varchar(10),
	CONSTRAINT PK_KETQUATHI PRIMARY KEY(MAHV, MAMH, LANTHI)
)

-- Cau 1--
ALTER TABLE LOP ADD CONSTRAINT FK_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)

ALTER TABLE LOP ADD CONSTRAINT FK_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE HOCVIEN ADD CONSTRAINT FK_HVMALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE KHOA ADD CONSTRAINT FK_TRGKHOA_GV FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE MONHOC ADD CONSTRAINT FK_MAKHOA_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(40), DIEMTB NUMERIC(4,2), XEPLOAI VARCHAR(10)

-- Cau 2 --

ALTER TABLE HOCVIEN ADD CONSTRAINT CK_MAHV CHECK (len(MAHV) = 5 and left(MAHV, 3) = MALOP and cast(right(MAHV, 2) as int) > 0)

-- Cau 3 --

ALTER TABLE HOCVIEN ADD CONSTRAINT CK_GIOITINH_HV CHECK(GIOITINH = 'Nam' or GIOITINH = 'Nu')

ALTER TABLE GIAOVIEN  ADD CONSTRAINT CK_GIOITINH_GV CHECK(GIOITINH = 'Nam' or GIOITINH = 'Nu')

-- Cau 4 --

ALTER TABLE KETQUATHI ADD CONSTRAINT CK_DIEM CHECK(DIEM >= 0 and DIEM <= 10 and cast(right(DIEM, 3) as varchar) like '.__')

-- Cau 5 --

ALTER TABLE KETQUATHI ADD CONSTRAINT CK_KETQUA CHECK((DIEM < 5 and KQUA = 'Khong dat') or ((DIEM >= 5 and DIEM <= 10) and KQUA = 'Dat'))

-- Cau 6 --

ALTER TABLE KETQUATHI ADD CONSTRAINT CK_LANTHI CHECK(LANTHI >= 0 and LANTHI <= 3)

-- Cau 7 --

ALTER TABLE GIANGDAY ADD CONSTRAINT CK_HOCKY CHECK(HOCKY >= 1 and HOCKY <= 3)

-- Cau 8 --
ALTER TABLE GIAOVIEN ADD CHECK(HOCVI in ('CN','KS', 'Ths','TS','PTS'))	

-- Cau 11 --
ALTER TABLE HOCVIEN ADD CONSTRAINT CHECK_TUOI CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

-- Cau 12 --
ALTER TABLE GIANGDAY ADD CONSTRAINT CHECK_GIANGDAY_NGAY CHECK (TUNGAY < DENNGAY)

-- Cau 13 --
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_TUOILAM CHECK (YEAR(NGVL) - YEAR(NGSINH) >= 22)

-- Cau 14 --
ALTER TABLE MONHOC ADD CONSTRAINT CHECK_TINCHI_MH CHECK (TCLT - TCTH >= 3)

-- Phan II --
SET DATEFORMAT dmy

-- Tat khoa ngoai de nhap du lieu --
ALTER TABLE DIEUKIEN nocheck constraint	ALL
ALTER TABLE GIANGDAY nocheck constraint ALL
ALTER TABLE GIAOVIEN nocheck constraint ALL
ALTER TABLE HOCVIEN nocheck constraint ALL
ALTER TABLE KETQUATHI nocheck constraint ALL 
ALTER TABLE KHOA nocheck constraint ALL
ALTER TABLE LOP nocheck constraint ALL 
ALTER TABLE MONHOC nocheck constraint ALL

INSERT INTO LOP VALUES('K11','Lop 1 khoa 1','K1108',11,'GV07')
INSERT INTO LOP VALUES('K12','Lop 2 khoa 1','K1205',12,'GV09')
INSERT INTO LOP VALUES('K13','Lop 3 khoa 1','K1305',12,'GV14')

INSERT INTO KHOA VALUES('KHMT','Khoa hoc may tinh','7/6/2005','GV01')
INSERT INTO KHOA VALUES('HTTT','He thong thong tin','7/6/2005','GV02')
INSERT INTO KHOA VALUES('CNPM','Cong nghe phan mem','7/6/2005','GV04')
INSERT INTO KHOA VALUES('MTT','Mang va truyen thong','20/10/2005','GV03')
INSERT INTO KHOA VALUES('KTMT','Ky thuat may tinh','20/12/2005','Null')

INSERT INTO GIAOVIEN VALUES('GV01','Ho Thanh Son','PTS','GS','Nam','2/5/1950','11/1/2004',5,2250000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.5,2025000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV03','Do Nghiem Phung','TS','GS','Nu','1/8/1950','23/9/2004',4,1800000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','12/1/2005',4.5,2025000,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV05','Mai Thanh Danh','ThS','GV','Nam','12/3/1958','12/1/2005',3,1350000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV06','Tran Doan Hung','TS','GV','Nam','11/3/1953','12/1/2005',4.5,2025000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','1/3/2005',4,1800000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV08','Le Thi Tran','KS','Null','Nu','26/3/1974','1/3/2005',1.69,760500,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','1/3/2005',4,1800000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV10','Le Tran Anh Loan','KS','Null','Nu','17/7/1972','1/3/2005',1.86,837000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV11','Ho Thanh Tung','CN','GV','Nam','12/1/1980','15/5/2005',2.67,1201500,'MTT')
INSERT INTO GIAOVIEN VALUES('GV12','Tran Van Anh','CN','Null','Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV13','Nguyen Linh Dan','CN','Null','Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3,1350000,'MTT')
INSERT INTO GIAOVIEN VALUES('GV15','Le Ha Thanh','ThS','GV','Nam','4/5/1978','15/5/2005',3,1350000,'KHMT')

INSERT INTO MONHOC VALUES('THDC','Tin hoc dai cuong',4,1,'KHMT')
INSERT INTO MONHOC VALUES('CTRR','Cau truc roi rac',5,0,'KHMT')
INSERT INTO MONHOC VALUES('CSDL','Co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
INSERT INTO MONHOC VALUES('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
INSERT INTO MONHOC VALUES('DHMT','Do hoa may tinh',3,1,'KHMT')
INSERT INTO MONHOC VALUES('KTMT','Kien truc may tinh',3,0,'KTMT')
INSERT INTO MONHOC VALUES('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
INSERT INTO MONHOC VALUES('HDH','He dieu hanh',4,0,'KTMT')
INSERT INTO MONHOC VALUES('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
INSERT INTO MONHOC VALUES('LTCFW','Lap trinh C for win',3,1,'CNPM')
INSERT INTO MONHOC VALUES('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

INSERT INTO GIANGDAY VALUES ('K11','THDC','GV07',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K12','THDC','GV06',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K13','THDC','GV15',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTRR','GV08',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K11','CSDL','GV05',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K12','CSDL','GV09',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTDLGT','GV15',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K13','CSDL','GV05',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K13','DHMT','GV07',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','HDH','GV04',1,2007,'2/1/2007','18/2/2007')
INSERT INTO GIANGDAY VALUES ('K12','HDH','GV04',1,2007,'2/1/2007','20/3/2007')
INSERT INTO GIANGDAY VALUES ('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')

INSERT INTO DIEUKIEN VALUES ('CSDL','CTRR')
INSERT INTO DIEUKIEN VALUES ('CSDL','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('CTDLGT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('DHMT','THDC')
INSERT INTO DIEUKIEN VALUES ('LTHDT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKHTTT','CSDL')

INSERT INTO KETQUATHI VALUES ('K1101','CSDL',1,'20/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTDLGT',1,'28/12/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','THDC',1,'20/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTRR',1,'13/5/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',1,'20/7/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',3,'10/8/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',1,'28/12/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',2,'5/1/2007',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',3,'15/1/2007',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','THDC',1,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTRR',1,'13/5/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL',1,'20/7/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL',2,'27/7/2006',8.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTDLGT',1,'28/12/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTRR',1,'13/5/2006',6.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',1,'13/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',2,'20/5/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',3,'30/6/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CSDL',1,'20/7/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTDLGT',1,'28/12/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','THDC',1,'20/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTRR',1,'13/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CSDL',1,'20/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT',2,'5/1/2007',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC',2,'27/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',1,'13/5/2006',3,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',2,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',3,'30/6/2006',6.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CSDL',1,'20/7/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTDLGT',1,'28/12/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','THDC',1,'20/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTRR',1,'13/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CSDL',1,'20/7/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTRR',1,'13/5/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTDLGT',1,'25/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','THDC',1,'20/5/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTRR',1,'13/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CSDL',1,'20/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTDLGT',1,'25/7/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTRR',1,'13/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CSDL',1,'20/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',1,'25/7/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',2,'7/8/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','THDC',1,'20/5/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR',2,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CSDL',1,'20/12/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','THDC',1,'20/5/2006',5.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTRR',1,'13/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CSDL',1,'20/12/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CTDLGT',1,'25/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CTRR',1,'13/5/2006',10,'Dat')

INSERT INTO HOCVIEN VALUES ('K1101', 'Nguyen Van', 'A', '27/01/1986', 'Nam','TPHCM','K11')
INSERT INTO HOCVIEN VALUES ('K1102', 'Tran Ngoc', 'Han', '14/03/1986', 'Nu','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES ('K1103', 'Ha Duy', 'Lap', '18/4/1986', 'Nam', 'Nghe An', 'K11')
INSERT INTO HOCVIEN VALUES ('K1104', 'Tran Ngoc', 'Linh', '30/3/1986', 'Nu', 'Tay Ninh', 'K11')
INSERT INTO HOCVIEN VALUES ('K1105', 'Tran Minh', 'Long', '27/2/1986', 'Nam', 'TPHCM', 'K11')
INSERT INTO HOCVIEN VALUES ('K1106', 'Le Nhat', 'Minh', '24/1/1986', 'Nam', 'TPHCM', 'K11')
INSERT INTO HOCVIEN VALUES ('K1107', 'Nguyen Nhu', 'Nhut','27/1/1986', 'Nam', 'Ha Noi', 'K11')
INSERT INTO HOCVIEN VALUES ('K1108', 'Nguyen Manh', 'Tam', '27/2/1986', 'Nam', 'Kien Giang', 'K11')
INSERT INTO HOCVIEN VALUES ('K1109', 'Phan Thi Thanh', 'Tam', '27/1/1986', 'Nu', 'Vinh Long', 'K11')
INSERT INTO HOCVIEN VALUES ('K1110', 'Le Hoai', 'Thuong', '5/2/1986', 'Nu', 'Can Tho', 'K11')
INSERT INTO HOCVIEN VALUES ('K1111', 'Le Ha', 'Vinh', '25/12/1986', 'Nam', 'Vinh Long', 'K11')
INSERT INTO HOCVIEN VALUES ('K1201', 'Nguyen Van', 'B', '11/2/1986', 'Nam', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1202', 'Nguyen Thi Kim', 'Duyen', '18/1/1986', 'Nu', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1203', 'Tran Thi Kim', 'Duyen', '17/9/1986', 'Nu', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1204', 'Truong My', 'Hanh', '19/5/1986', 'Nu', 'Dong Nai', 'K12')
INSERT INTO HOCVIEN VALUES ('K1205', 'Nguyen Thanh', 'Nam', '17/4/1986', 'Nam', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1206', 'Nguyen Thi Truc', 'Thanh','4/3/1986','Nu', 'Kien Giang', 'K12')
INSERT INTO HOCVIEN VALUES ('K1207', 'Tran Thi Bich', 'Thuy', '8/2/1986', 'Nu', 'Nghe An', 'K12')
INSERT INTO HOCVIEN VALUES ('K1208', 'Huynh Thi Kim', 'Trieu', '8/4/1986', 'Nu', 'Tay Ninh', 'K12')
INSERT INTO HOCVIEN VALUES ('K1209', 'Pham Thanh', 'Trieu', '23/2/1986', 'Nam', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1210', 'Ngo Thanh', 'Tuan', '14/2/1986', 'Nam', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1211', 'Do Thi','Xuan', '9/3/1986', 'Nu', 'Ha Noi', 'K12')
INSERT INTO HOCVIEN VALUES ('K1212', 'Le Thi Phi', 'Yen', '12/3/1986', 'Nu', 'TPHCM', 'K12')
INSERT INTO HOCVIEN VALUES ('K1301', 'Nguyen Thi Kim','Cuc' , '9/6/1986', 'Nu', 'Kien Giang', 'K13')
INSERT INTO HOCVIEN VALUES ('K1302', 'Truong Thi My', 'Hien', '18/3/1986', 'Nu', 'Nghe An', 'K13')	
INSERT INTO HOCVIEN VALUES ('K1303', 'Le Duc', 'Hien', '21/3/1986', 'Nam', 'Tay Ninh', 'K13')
INSERT INTO HOCVIEN VALUES ('K1304', 'Le Quang', 'Hien', '18/4/1986', 'Nam', 'TPHCM', 'K13')
INSERT INTO HOCVIEN VALUES ('K1305', 'Le Thi', 'Huong', '27/3/1986','Nu', 'TPHCM', 'K13')
INSERT INTO HOCVIEN VALUES ('K1306', 'Nguyen Thai', 'Huu', '30/3/1986', 'Nam', 'Ha Noi', 'K13')
INSERT INTO HOCVIEN VALUES ('K1307', 'Tran Minh', 'Man', '28/5/1986', 'Nam','TPHCM', 'K13')
INSERT INTO HOCVIEN VALUES ('K1308', 'Nguyen Hieu' ,'Nghia', '8/4/1986', 'Nam', 'Kien Giang' , 'K13')
INSERT INTO HOCVIEN VALUES ('K1309', 'Nguyen Trung', 'Nghia', '18/1/1987', 'Nam', 'Nghe An', 'K13')
INSERT INTO HOCVIEN VALUES ('K1310', 'Tran Thi Hong', 'Tham', '22/4/1986', 'Nu', 'Tay Ninh', 'K13')
INSERT INTO HOCVIEN VALUES ('K1311', 'Tran Minh', 'Thuc', '4/4/1986', 'Nam', 'TPHCM', 'K13')
INSERT INTO HOCVIEN VALUES ('K1312', 'Nguyen Thi Kim', 'Yen', '7/9/1986', 'Nu', 'TPHCM', 'K13')

-- Bat lai khoa ngoai --
ALTER TABLE MONHOC CHECK CONSTRAINT ALL
ALTER TABLE DIEUKIEN CHECK CONSTRAINT ALL
ALTER TABLE GIAOVIEN CHECK CONSTRAINT ALL
ALTER TABLE HOCVIEN CHECK CONSTRAINT ALL
ALTER TABLE KETQUATHI CHECK CONSTRAINT ALL
ALTER TABLE KHOA CHECK CONSTRAINT ALL
ALTER TABLE LOP CHECK CONSTRAINT ALL
ALTER TABLE GIANGDAY CHECK CONSTRAINT ALL

-- Cau 1 -- 

SELECT GIAOVIEN.HOTEN, GIAOVIEN.MAGV, GIAOVIEN.HESO, KHOA.TRGKHOA 
FROM GIAOVIEN 
JOIN KHOA 
ON GIAOVIEN.MAGV = KHOA.TRGKHOA

UPDATE GIAOVIEN 
SET HESO = HESO + 0.2 
FROM GIAOVIEN 
JOIN KHOA 
ON GIAOVIEN.MAGV = KHOA.TRGKHOA

-- Cau 2 --
UPDATE HocVien
SET DiemTB = (
	SELECT AVG(Diem)
	FROM KetQuaThi
	WHERE LanThi = (SELECT MAX(LanThi) FROM KetQuaThi KQ WHERE MaHV = KetQuaThi.MaHV GROUP BY MaHV)
	GROUP BY MaHV
	HAVING MaHV = HocVien.MaHV
)

-- Cau 3 --
SELECT * 
FROM HOCVIEN, KETQUATHI 
WHERE (KETQUATHI.LANTHI = 3 AND KETQUATHI.DIEM < 5 AND KETQUATHI.MAHV = HOCVIEN.MAHV)

UPDATE HOCVIEN 
SET GHICHU = 'Cam Thi' 
FROM HOCVIEN, KETQUATHI 
WHERE (KETQUATHI.LANTHI = 3 AND KETQUATHI.DIEM < 5 AND KETQUATHI.MAHV = HOCVIEN.MAHV)

-- Cau 4 --
UPDATE HOCVIEN
SET DIEMTB = (
CASE	
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 and DIEMTB < 9 THEN 'G'
	WHEN DIEMTB >= 6.5 and DIEMTB < 8 THEN 'K'
	WHEN DIEMTB >= 5 and DIEMTB < 6.5 THEN 'TB'	
	WHEN DIEMTB < 5 THEN 'Y'
END
)


-- Phan III --
-- Cau 1 --
SELECT MAHV, HO + ' ' + TEN AS HOTEN, NGSINH, MALOP
FROM HOCVIEN 
WHERE MAHV IN (SELECT TRGLOP FROM LOP)

-- Cau 2 --
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, LANTHI, DIEM 
FROM HOCVIEN HV 
JOIN KETQUATHI KQ 
ON HV.MAHV = KQ.MAHV 
WHERE HV.MALOP = 'K12' AND KQ.MAMH = 'CTRR' 
ORDER BY HV.TEN, HV.HO


-- Cau 3 --
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN 
FROM HOCVIEN HV 
JOIN KETQUATHI KQ 
ON HV.MAHV = KQ.MAHV 
WHERE KQ.LANTHI = 1 AND KQ.KQUA = 'Dat'


-- Cau 4 --
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN 
FROM HOCVIEN HV 
JOIN KETQUATHI KQ 
ON HV.MAHV = KQ.MAHV 
WHERE HV.MALOP = 'K11' AND KQ.MAMH = 'CTRR' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong Dat'


-- Cau 5 --
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS HOTEN 
FROM HOCVIEN HV 
JOIN KETQUATHI KQ 
ON HV.MAHV = KQ.MAHV 
WHERE HV.MALOP LIKE 'K%' AND MAMH = 'CTRR' AND NOT EXISTS (
	SELECT *
	FROM KETQUATHI 
	WHERE KQUA = 'Dat' AND HV.MAHV = KETQUATHI.MAMH
)

-- Cau 6 --
SELECT DISTINCT MH.TENMH 
FROM MONHOC MH, GIANGDAY GD, GIAOVIEN GV 
WHERE MH.MAMH = GD.MAMH AND GV.MaGV = GD.MaGV AND GD.HOCKY = 1 AND GD.NAM = 2006 AND GV.HOTEN = 'Tran Tam Thanh'


-- Cau 7 --
SELECT DISTINCT MH.MAMH, MH.TENMH
FROM MONHOC MH JOIN GIANGDAY GD
ON MH.MAMH = GD.MAMH
WHERE GD.HOCKY = 1
	AND GD.NAM = 2006
	AND GD.MAGV = (
	  	SELECT MAGV 
	  	FROM LOP 
	  	WHERE MALOP = 'K11'
	)

-- Cau 8 --
SELECT HO + ' ' + TEN AS HOTEN 
FROM HOCVIEN HV JOIN LOP
ON HV.MAHV = LOP.TRGLOP
WHERE HV.MALOP = ( 
	SELECT GD.MALOP 
	FROM GIANGDAY GD
	JOIN GIAOVIEN GV 
	ON GD.MAGV = GV.MAGV 
	WHERE GD.MAMH = 'CSDL' AND GV.HOTEN = 'Nguyen To Lan'
)

-- Cau 9 --
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
	SELECT DK.MAMH_TRUOC
	FROM MONHOC MH JOIN DIEUKIEN DK
	ON MH.MAMH = DK.MAMH
	WHERE MH.TENMH = 'Co So Du Lieu'
)

-- Cau 10 --
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH 
WHERE MH.MAMH IN (
	SELECT DK.MAMH
	FROM MONHOC MH JOIN DIEUKIEN DK
	ON MH.MAMH = DK.MAMH_TRUOC
	WHERE MH.TENMH = 'Cau truc roi rac'
)

-- Cau 11 --
SELECT GV.HOTEN 
FROM GIAOVIEN GV, GIANGDAY GD
JOIN GIANGDAY GD
ON GV.MAGV  = GD.MAGV
WHERE GD.MALOP = 'K11'​ AND GD.HOCKY = 1 AND GD.NAM = 2006
INTERSECT (
	SELECT GV.HOTEN 
	FROM GIAOVIEN GV
	JOIN GIANGDAY GD
	ON GV.MAGV  = GD.MAGV
	WHERE  GD.MALOP = 'K12'​ AND GD.HOCKY = 1 AND GD.NAM = 2006
)

-- Cau 12 --
SELECT DISTINCT HV.MAHV , HV.HO  + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
JOIN KETQUATHI KQ 
ON HV.MAHV = KQ.MAHV 
WHERE KQ.MAMH = 'CSDL' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong Dat' AND NOT EXISTS (
	SELECT *
	FROM KETQUATHI KQ
	WHERE KQ.MAHV = HV.MAHV AND KQ.LANTHI > 1
)

-- Cau 13 --
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV 
WHERE GV.MAGV NOT IN (
	SELECT MAGV
	FROM GIANGDAY
)

-- Cau 14 --
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV 
WHERE NOT EXISTS (
	SELECT *
	FROM GIANGDAY GD
	JOIN MONHOC MH
	ON GD.MAMH = MH.MAMH 
	WHERE GD.MAGV = GD.MAGV AND MH.MAKHOA = GV.MAKHOA 
)

-- Cau 15 --
SELECT DISTINCT HV.HO  + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
WHERE MALOP = 'K11' AND (
	EXISTS (
		SELECT *
		FROM KETQUATHI KQ
		WHERE LANTHI > 3 AND KQUA = 'Khong Dat' AND HV.MAHV = KQ.MAHV
	) OR EXISTS (
		SELECT *
		FROM KETQUATHI KQ
		WHERE KQ.MAMH = 'CTRR' AND KQ.LANTHI = 2 AND KQ.DIEM = 5 AND HV.MAHV = KQ.MAHV 
	)
)

-- Cau 16 --
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN GIANGDAY GD
ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR'		
GROUP BY HOTEN, HOCKY, NAM
HAVING COUNT(*) >= 2

-- Cau 17 --
SELECT HV.* , KQ.DIEM AS 'DIEM THI CUOI CUNG'
FROM HOCVIEN HV JOIN KETQUATHI KQ
ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL' AND LANTHI = ( 
	SELECT MAX(LANTHI)
	FROM KETQUATHI 
	WHERE HV.MAHV = KQ.MAHV AND KQ.MAMH = 'CSDL'
)

-- Cau 18 --
SELECT HV.*, KQ.DIEM AS 'DIEM CAO NHAT'
FROM HOCVIEN HV JOIN KETQUATHI KQ
ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL' AND KQ.DIEM = ( 
	SELECT MAX(DIEM) 
	FROM KETQUATHI
	WHERE KETQUATHI.MAHV = HV.MAHV AND KETQUATHI.MAMH = 'CSDL'
	GROUP BY MAHV
)





