create table banks(
    bank_id varchar(20) primary key, -- clever-bank, some-other-bank, ...
	bank_name varchar(100) unique not null 
);

create table bank_clients(
    client_id varchar(10) primary key, -- passport id 
	client_full_name varchar(50) not null, 
	client_bank_id varchar(20) not null references banks(bank_id) 
);

create table bank_accounts(
    acc_id char(28) primary key, -- из выписки
	acc_id_within_bank char(10) unique not null, -- из чека
	acc_client_id varchar(34) not null references bank_clients(client_id),
	acc_open_date date not null, 
	acc_close_date date
);

create table bank_acc_balance(
    acc_id char(28) not null references bank_accounts(acc_id),
	amount numeric(19,2) not null,
	amount_start_ts timestamp not null,
	amount_end_ts timestamp,
	amount_is_current boolean default true,
	constraint check__bank_acc_balance__amount_is_current check (amount_is_current or amount_is_current is null),
	primary key (acc_id, amount_start_ts),
	unique (acc_id, amount_is_current)
);


create table bank_transactions(
    txn_id bigserial primary key,
	txn_type char(1) not null,
	txn_acc_id_from char(28) references bank_accounts(acc_id),
	txn_acc_id_to char(28) references bank_accounts(acc_id),
	amount numeric(8,2) not null,
	txn_info varchar(100),
	constraint check__bank_transactions__txn_type check (txn_type in ('+', '-', '>'))
);

INSERT INTO public.banks (bank_id,bank_name) VALUES
	 ('C852L3681E44V99E723R','Clever-Bank'),
	 ('89R2O368S144V9965E67','Rose-Bank'),
	 ('7M920333A13I56965N77','Main-Bank'),
	 ('79Y2O76381U552965R77','Your-Bank'),
	 ('91G0O71381L442265D95','Gold-Bank');

INSERT INTO public.bank_clients (client_id,client_full_name,client_bank_id) VALUES
	 ('75E99V43N','Иванов Николай Федорович','C852L3681E44V99E723R'),
	 ('89L95G52F','Белая Жанна Андреевна','C852L3681E44V99E723R'),
	 ('55O38H17K','Иванов Иван Иванович','C852L3681E44V99E723R'),
	 ('47N94A87Q','Петрова Анастасия Андреевна','C852L3681E44V99E723R'),
	 ('56A85M17S','Котова Лидия Сергеевна','89R2O368S144V9965E67'),
	 ('98U15F37D','Карась Сергей Анатольевич','89R2O368S144V9965E67'),
	 ('81B425N16P','Носов Дмитрий Артемович','89R2O368S144V9965E67'),
	 ('45U727C96H','Серая Кристина Олеговна','89R2O368S144V9965E67'),
	 ('21A345V90W','Ландышева Зинаида Павловна','7M920333A13I56965N77'),
	 ('55C942K56F','Иванов Петр Дмитриевич','7M920333A13I56965N77');
INSERT INTO public.bank_clients (client_id,client_full_name,client_bank_id) VALUES
	 ('71C541L81S','Петрова Екатерина Сергеевна','7M920333A13I56965N77'),
	 ('56F721U35K','Петров Семен Антонович','7M920333A13I56965N77'),
	 ('90L331T28C','Егоров Матвей Антонович','79Y2O76381U552965R77'),
	 ('96F572J39Y','Белый Борис Павлович','79Y2O76381U552965R77'),
	 ('57K632R10P','Иванова Юлия Михайловна','79Y2O76381U552965R77'),
	 ('11K562L66K','Петрович Евгения Юрьевна','79Y2O76381U552965R77'),
	 ('32H573T99K','Золотая Анна Михайловна','91G0O71381L442265D95'),
	 ('12H343B89K','Лебедева Марина Павловна','91G0O71381L442265D95'),
	 ('92P343C81K','Михайлов Денис Иванович','91G0O71381L442265D95'),
	 ('98P765C84K','Иванов Василий Степанович','91G0O71381L442265D95');
INSERT INTO public.bank_accounts (acc_id,acc_id_within_bank,acc_client_id,acc_open_date,acc_close_date) VALUES
	 ('AS12 ASDG 1200 2159 ADSA 533A 2312','1023456789','75E99V43N','1997-12-12','2026-12-12'),
	 ('NE72 ASFM 1980 3874 DQLS 589A 3397','9876254321','89L95G52F','2000-08-03','2030-08-03'),
	 ('KF12 ASMG 3879 9812 AOSA 333A 9876','1122121111','55O38H17K','2013-10-05','2035-10-05'),
	 ('AA89 KLMN 9999 4554 DABC 778A 9876','9871237612','55O38H17K','2009-10-12','2027-10-12'),
	 ('AB12 CDEF 3456 7899 GHIJ 778K 9876','4567982138','47N94A87Q','2017-10-12','2047-10-12'),
	 ('AB09 CDEF 8765 4321 GHIJ 101K 1111','4817083138','56A85M17S','2017-10-09','2047-10-09'),
	 ('BA10 EDKF 1991 5656 GHIJ 812K 7123','4911283155','98U15F37D','2012-10-09','2042-10-09'),
	 ('BA31 EDKF 1221 5176 GHIJ 982K 7513','4913333155','81B425N16P','2012-10-09','2042-10-09'),
	 ('BK81 EHCF 8236 9255 ISDB 959K 3884','4615789155','45U727C96H','2012-10-09','2042-10-09'),
	 ('SA81 EHCF 9246 7315 IKLB 959K 1004','8616183018','21A345V90W','2012-10-09','2042-10-09');
INSERT INTO public.bank_accounts (acc_id,acc_id_within_bank,acc_client_id,acc_open_date,acc_close_date) VALUES
	 ('KN11 UCAF 3876 7315 IKLB 959K 1004','7248617118','55C942K56F','2004-03-11','2028-03-11'),
	 ('AN11 ACAF 3226 7115 IABC 979K 2256','5246781118','71C541L81S','2004-12-12','2028-12-12'),
	 ('VW22 BKLF 3186 7115 KLMN 921K 2226','2999652270','56F721U35K','2018-12-12','2058-12-12'),
	 ('SA33 ABCD 1234 0987 EFJH 111K 2222','7379614270','90L331T28C','2018-12-12','2058-12-12'),
	 ('CS48 ABCD 5671 7476 EFJH 345K 6987','2177654299','96F572J39Y','2018-12-12','2058-12-12'),
	 ('BA49 DABC 5671 7476 EFJH 345K 6987','4444614259','57K632R10P','2018-12-12','2058-12-12'),
	 ('BA87 DABC 5321 0972 EFJH 917K 8009','4864614259','11K562L66K','2009-01-25','2039-01-25'),
	 ('BA17 DABC 5121 0882 EFJH 917K 8119','5546862259','32H573T99K','2009-01-25','2039-01-25'),
	 ('MN45 AAAA 6798 8080 EFJH 396K 7777','5566123467','12H343B89K','2016-12-13','2046-12-13'),
	 ('MN29 AAAA 6718 1111 EFJH 316H 7457','5134523400','92P343C81K','2016-12-13','2046-12-13');
INSERT INTO public.bank_accounts (acc_id,acc_id_within_bank,acc_client_id,acc_open_date,acc_close_date) VALUES
	 ('AN21 ABCA 2217 1651 EFJH 316H 7431','2190653410','98P765C84K','2016-12-13','2046-12-13'),
	 ('AL18 ABCA 3355 2389 EFJH 000H 7431','0921568732','75E99V43N','2000-05-05','2030-05-05'),
	 ('MA61 ABAA 3445 1388 NMLK 560H 3709','9346561232','89L95G52F','2000-05-05','2030-05-05'),
	 ('MA12 ABAA 3125 1128 NMLK 520H 1221','1345638232','47N94A87Q','2017-05-15','2047-05-15'),
	 ('MA72 ABAA 3905 4128 NMLK 520H 7421','1388728232','56A85M17S','2017-05-15','2047-05-15'),
	 ('AA56 AHAA 3805 8888 NHKK 542A 2561','1676545748','98U15F37D','2017-05-09','2047-05-09'),
	 ('AA06 AHAA 1800 8008 NHKK 502A 7788','4238490448','81B425N16P','2017-05-09','2047-05-09'),
	 ('AA99 AHAA 1910 8998 NHKK 502A 7128','9900231248','45U727C96H','2017-05-09','2047-05-09'),
	 ('WA15 ANVA 8760 4567 NMNK 112A 6728','1901131245','21A345V90W','2008-01-01','2048-01-01'),
	 ('WA88 ANVA 1296 4167 NMNK 102A 0008','7568731240','55C942K56F','2008-01-01','2048-01-01');
INSERT INTO public.bank_accounts (acc_id,acc_id_within_bank,acc_client_id,acc_open_date,acc_close_date) VALUES
	 ('WA18 ANVA 1116 8867 NMNK 145A 0408','9561199249','71C541L81S','2008-03-03','2048-03-03'),
	 ('WA11 ANVA 1111 6757 NMNK 182A 3438','4589564391','56F721U35K','2008-03-03','2048-03-03'),
	 ('HA77 BDBD 6751 0000 AHHA 133A 1238','1589121212','90L331T28C','1998-03-12','2028-03-12'),
	 ('HA07 BDBD 0051 0450 AHHA 103A 0038','6543456789','96F572J39Y','1998-03-12','2028-03-12'),
	 ('HA22 BDBD 0221 9050 AHHA 563A 0118','7890045600','57K632R10P','1998-03-12','2028-03-12'),
	 ('AH22 BDBD 0221 9050 AHHA 563A 0118','7999804590','11K562L66K','1998-03-12','2028-03-12'),
	 ('AH12 BDBD 0111 9151 AHHA 763A 4444','0234564590','32H573T99K','2006-06-16','2046-06-16'),
	 ('NN61 ABCD 8866 9751 AMLA 567A 8935','8765345655','12H343B89K','2006-06-16','2046-06-16'),
	 ('NN39 ABCD 3492 7340 AMLA 507A 9295','8734348844','92P343C81K','2011-10-25','2051-10-25'),
	 ('NN19 ABCD 3222 2342 AMLA 202A 1293','8999348128','98P765C84K','2011-10-25','2051-10-25');
INSERT INTO public.bank_acc_balance (acc_id,amount,amount_start_ts,amount_end_ts,amount_is_current) VALUES
	 ('MN45 AAAA 6798 8080 EFJH 396K 7777',264.45,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AN21 ABCA 2217 1651 EFJH 316H 7431',27423.14,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AL18 ABCA 3355 2389 EFJH 000H 7431',190000.73,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('MA61 ABAA 3445 1388 NMLK 560H 3709',8812.98,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('MA12 ABAA 3125 1128 NMLK 520H 1221',16261.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('MA72 ABAA 3905 4128 NMLK 520H 7421',16261.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AA56 AHAA 3805 8888 NHKK 542A 2561',10001.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AA06 AHAA 1800 8008 NHKK 502A 7788',10231.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AA99 AHAA 1910 8998 NHKK 502A 7128',11122.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('WA15 ANVA 8760 4567 NMNK 112A 6728',1111.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true);
INSERT INTO public.bank_acc_balance (acc_id,amount,amount_start_ts,amount_end_ts,amount_is_current) VALUES
	 ('WA88 ANVA 1296 4167 NMNK 102A 0008',1000.91,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('WA18 ANVA 1116 8867 NMNK 145A 0408',10001.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('WA11 ANVA 1111 6757 NMNK 182A 3438',122209.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('NE72 ASFM 1980 3874 DQLS 589A 3397',20177.92,'2023-09-02 00:00:00.000','2023-09-02 00:00:00.000',true),
	 ('AS12 ASDG 1200 2159 ADSA 533A 2312',1133.88,'2023-09-03 00:00:00.000','2008-05-30 00:00:00.000',true),
	 ('HA77 BDBD 6751 0000 AHHA 133A 1238',100000.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AA89 KLMN 9999 4554 DABC 778A 9876',461.54,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('KF12 ASMG 3879 9812 AOSA 333A 9876',1456.19,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('BA10 EDKF 1991 5656 GHIJ 812K 7123',73598.73,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('BA31 EDKF 1221 5176 GHIJ 982K 7513',21309.56,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true);
INSERT INTO public.bank_acc_balance (acc_id,amount,amount_start_ts,amount_end_ts,amount_is_current) VALUES
	 ('BK81 EHCF 8236 9255 ISDB 959K 3884',653462358.47,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('KN11 UCAF 3876 7315 IKLB 959K 1004',4873.18,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AN11 ACAF 3226 7115 IABC 979K 2256',35929.17,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('HA07 BDBD 0051 0450 AHHA 103A 0038',100.01,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('SA33 ABCD 1234 0987 EFJH 111K 2222',37824.12,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('HA22 BDBD 0221 9050 AHHA 563A 0118',1004.01,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('CS48 ABCD 5671 7476 EFJH 345K 6987',37285.68,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('BA49 DABC 5671 7476 EFJH 345K 6987',12000.12,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('BA17 DABC 5121 0882 EFJH 917K 8119',3275.12,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AH22 BDBD 0221 9050 AHHA 563A 0118',2004.01,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true);
INSERT INTO public.bank_acc_balance (acc_id,amount,amount_start_ts,amount_end_ts,amount_is_current) VALUES
	 ('AH12 BDBD 0111 9151 AHHA 763A 4444',201445.01,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('NN61 ABCD 8866 9751 AMLA 567A 8935',20141.01,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('NN39 ABCD 3492 7340 AMLA 507A 9295',11141.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('NN19 ABCD 3222 2342 AMLA 202A 1293',1219.11,'2023-09-01 10:26:10.119','2023-09-01 10:27:14.127',true),
	 ('AB12 CDEF 3456 7899 GHIJ 778K 9876',989.63,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('VW22 BKLF 3186 7115 KLMN 921K 2226',5827.34,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('AB09 CDEF 8765 4321 GHIJ 101K 1111',56038.65,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('MN29 AAAA 6718 1111 EFJH 316H 7457',27507.71,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('BA87 DABC 5321 0972 EFJH 917K 8009',24207.83,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true),
	 ('SA81 EHCF 9246 7315 IKLB 959K 1004',867422.82,'2023-09-03 00:00:00.000','2023-09-03 00:00:00.000',true);
INSERT INTO public.bank_transactions (txn_type,txn_acc_id_from,txn_acc_id_to,amount,txn_info) VALUES
	 ('+','AB12 CDEF 3456 7899 GHIJ 778K 9876','AB12 CDEF 3456 7899 GHIJ 778K 9876',20.15,NULL),
	 ('-','VW22 BKLF 3186 7115 KLMN 921K 2226','VW22 BKLF 3186 7115 KLMN 921K 2226',48.13,NULL),
	 ('>','BA87 DABC 5321 0972 EFJH 917K 8009','MN29 AAAA 6718 1111 EFJH 316H 7457',34.55,NULL),
	 ('+','BA87 DABC 5321 0972 EFJH 917K 8009','BA87 DABC 5321 0972 EFJH 917K 8009',26.12,NULL),
	 ('+','SA81 EHCF 9246 7315 IKLB 959K 1004','SA81 EHCF 9246 7315 IKLB 959K 1004',40.77,NULL),
	 ('+','SA81 EHCF 9246 7315 IKLB 959K 1004','SA81 EHCF 9246 7315 IKLB 959K 1004',66.77,NULL);
