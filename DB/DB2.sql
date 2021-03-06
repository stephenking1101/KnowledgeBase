-- instead of "delete from " ----------------------------------------
alter table stm.portfolio_valuation ACTIVATE NOT LOGGED INITIALLY WITH EMPTY TABLE 

create table s28.person(pers_name char(10) not null,pers_address varchar(50) not null,pers_birth_date dec(8) not null,pers_update_time dec(17) not null, constraint pk_pers primary key nonclustered (pers_name));

create table logging(logg_user char(16) not null,logg_action varchar(50) not null,logg_update_time dec(17) not null, constraint pk_logg primary key (logg_user,logg_update_time));

select * from s28.person;

delete from s28.person where name='Stephen';

insert into s28.person values('Stephen','Guangzhou',1101);

update s28.person set birthdate=19841101 where name='Stephen';

alter table s28.person modify pers_name char(10) not null;
alter table s28.person add pers_company varchar(30) not null;
alter table s28.person drop person_name;
alter table fos.PROFILE_INVESTMENT_SECTION add EXECUTION_ONLY_PERCENT DECIMAL(6);

list tables for schema [];

describe table [];

select * from HUB.SSBKLSPH where V7MDFL!='' fetch first 10 rows only;

replace(ltrim(replace(rtrim(char(cast(10.11 as decimal(15,5)))),'0',' ')),' ','0');

db2 connect to estmuaed user fos using republic
db2 drop procedure fos.pi_system
db2 -td@ -f pi_system.sql
db2 call fos.pi_system

REVOKE  CREATETAB,BINDADD ON DATABASE  FROM USER FOS;
GRANT  CREATETAB ON DATABASE  TO USER DB2ADMIN;
GRANT EXECUTE ON PROCEDURE FOS.* TO USER test WITH GRANT OPTION;
GRANT CREATEIN,DROPIN ON SCHEMA FOS TO USER TEST WITH GRANT OPTION;

CATALOG TCPIP NODE ECRMUAES REMOTE pdcpbrss03 SERVER 50000
CATALOG DATABASE ECRMUAES AS ECRMUAES AT NODE ECRMUAES

-- order feature ----------------------------------------
select * from FOS.CUSTOMER_ASSET_ALLOCATION where customer_number = '0054062898' ORDER BY abs(alt_limit_percent) desc, alt_limit_percent desc

-- cast long to timestamp ----------------------------------------
select timestamp('1970-01-01 00:00:00') + (1164601881766/1000) second from FOS.SYSTEM_PARAMETER

select rtrim('0' || char(replace(replace(customer_number,'-',''),' ',''))),
           profile_key,
           profile_version
      from profile_customer
     where (profile_key,
            profile_version) in (
                                 select profile_key,
                                        max(profile_version)
                                   from profile_approval
                                  where profile_key in (
                                                        select b.profile_key
                                                          from fos.profile_approval b
                                                         where b.status <> 'A'
                                                           and b.profile_version = 0
                                                           and b.active_flag = 'A')
                                    and status = 'A'
                                    and active_flag = 'A'
                                  group by profile_key)
       and length(replace(replace(customer_number,'-',''),' ','')) = 9
       and customer_number is not null;

-- except all ----------------------------------------
select 'A' as active_flag,customer_number,country_code,group_member,account_branch,account_sn,account_suffix,GGACNA as account_name
                from GHSS.HSACMSP as g,fos.wms_customer_ghss_account_mapping as w
                where GGCTCD = w.country_code
                  and GGGMAB = group_member
                  and GGACB = account_branch
                  and GGACS = account_sn
                  and GGACX = account_suffix
                  and cast('0'||left(char(GGDCB),3)||left(char(GGDCS),6) as varchar(12))=w.customer_number
                  and w.customer_number= cur_customer_number
                  and w.active_flag = 'A'
                )
                EXCEPT ALL
                (  SELECT
                        active_flag,
                        customer_number,
                        country_code,
                        group_member,
                        account_branch,
                        account_sn,
                        account_suffix,
                        account_name
                    FROM
                        fos.ghss_account
                    WHERE
                        customer_number = cur_customer_number
                );

-- case ----------------------------------------
CASE  SALE_DEAL_NO WHEN  -1 THEN NULL ELSE SALE_VALUE -  ld_new_order_price * BOUGHT_QTY  END

-- merge into ----------------------------------------
 MERGE INTO FOS.WMS_CUSTOMER_GHSS_ACCOUNT_MAPPING T1
        USING(
            SELECT DISTINCT
                '0'||RTRIM(LTRIM(C.HSBC_CODE)) AS CUSTOMER_NUMBER,
                GHSS_CODE,
                GHSS_AC_NAME
            FROM WMS.WMCRS_CUSTOMER_MASTER AS C,WMS.WMCRS_CUSTOMER_GHSS_ACCOUNT_MAPPING AS M
            WHERE 
                M.CUST_SYSCODE=C.CUST_SYSCODE
                AND LENGTH(M.GHSS_CODE) = 18
                /*ADDED BY RYAN LIU 03AUG2006*/
                AND LENGTH(RTRIM(LTRIM(TRANSLATE(M.GHSS_CODE, '', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')))) = 12
                AND LENGTH(RTRIM(LTRIM(TRANSLATE(C.HSBC_CODE, '', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')))) = 9
                /* END ADDED BY RYAN LIU*/
        ) T2
        ON(
            T1.COUNTRY_CODE = LEFT(GHSS_CODE,2)
            AND T1.GROUP_MEMBER = LEFT(SUBSTR(GHSS_CODE,3),4)
            AND T1.ACCOUNT_BRANCH = DECIMAL(SUBSTR(GHSS_CODE,7,3),3,0)
            AND T1.ACCOUNT_SN = DECIMAL(SUBSTR(GHSS_CODE,10,6),6,0)
            AND T1.ACCOUNT_SUFFIX = DECIMAL(SUBSTR(GHSS_CODE,16,3),3,0)
        )
        WHEN MATCHED AND T1.CUSTOMER_NUMBER = T2.CUSTOMER_NUMBER THEN
            UPDATE SET (ACTIVE_FLAG, ACCOUNT_NAME) = ('A', T2.GHSS_AC_NAME)
        WHEN MATCHED AND T1.CUSTOMER_NUMBER <> T2.CUSTOMER_NUMBER THEN
            UPDATE SET (ACTIVE_FLAG,STATUS,CUSTOMER_NUMBER,ACCOUNT_NAME, UPDATE_TIMESTAMP) = ('A','E',T2.CUSTOMER_NUMBER,T2.GHSS_AC_NAME,CURRENT TIMESTAMP)
        WHEN NOT MATCHED THEN
            INSERT
            (
            ACTIVE_FLAG      ,
            CUSTOMER_NUMBER  ,
            COUNTRY_CODE     ,
            GROUP_MEMBER     ,
            ACCOUNT_BRANCH   ,
            ACCOUNT_SN       ,
            ACCOUNT_SUFFIX   ,
            ACCOUNT_NAME     ,
            STATUS           ,
            CREATE_TIMESTAMP
            )
            VALUES(
            'A',
            T2.CUSTOMER_NUMBER,
            LEFT(GHSS_CODE,2),
            LEFT(SUBSTR(GHSS_CODE,3),4),
            DECIMAL(SUBSTR(GHSS_CODE,7,3),3,0) ,
            DECIMAL(SUBSTR(GHSS_CODE,10,6),6,0) ,
            DECIMAL(SUBSTR(GHSS_CODE,16,3),3,0) ,
            GHSS_AC_NAME,
            'N',
            CURRENT TIMESTAMP);

-- between ----------------------------------------
select * from FOS.UNIT_TRUST_NAV_HISTORY where date(NAV_DATE) between '2008-03-01' and '2008-03-12'

-- export and import ----------------------------------------
export to d:\FOS.UNIT_TRUST_NAV_HISTORY.ixf of ixf select * from FOS.UNIT_TRUST_NAV_HISTORY where backup_date between '2007-11-05' and '2007-11-06';

IMPORT FROM "D:\FOS.UNIT_TRUST_NAV_HISTORY.ixf" OF IXF MESSAGES "D:\log.txt" REPLACE INTO FOS.UNIT_TRUST_NAV_HISTORY_TMP;

-- db backup and restore ----------------------------------------
CONNECT TO EFOSIN;
QUIESCE DATABASE IMMEDIATE FORCE CONNECTIONS;
CONNECT RESET;
BACKUP DATABASE EFOSIN TO "E:\data_convert_backup" WITH 2 BUFFERS BUFFER 1024 PARALLELISM 1 WITHOUT PROMPTING;
CONNECT TO EFOSIN;
UNQUIESCE DATABASE;
CONNECT RESET;

RESTORE DATABASE EFOSIN FROM "E:\data_convert_backup" TAKEN AT 20080211090550 WITH 2 BUFFERS BUFFER 1024 PARALLELISM 1 WITHOUT PROMPTING;

ROLLFORWARD DATABASE EFOSIN TO END OF LOGS AND COMPLETE;

-- 递归 ----------------------------------------:
iteration enquiry sql to get all the sub-task jobs in a tree under a parent task node:

with rpl ( EXEC_TASK_INST_NAME,  PARM_NAME  ,  PARM_SEQ_NO  ,  PARM_VALUE ) as
(
select EXEC_TASK_INST_NAME,  PARM_NAME  ,  PARM_SEQ_NO  ,  PARM_VALUE  from FOS.SCH_EXEC_TASK_INST_PARM  where EXEC_TASK_INST_NAME ='dts.efosind.ghss.copy.hsachdpe'
union all
select  child.EXEC_TASK_INST_NAME,  child.PARM_NAME  ,  child.PARM_SEQ_NO  ,  child.PARM_VALUE from rpl  parent, FOS.SCH_EXEC_TASK_INST_PARM child where parent.PARM_VALUE =child.EXEC_TASK_INST_NAME
)
select * from rpl;

create index session.PK_ORDER_ARCHIVE on session.tmp_ORDER_ARCHIVE (REF_NO, REF_SUBNO);

UPDATE session.cust_asset_alloc_tmp A
        SET 
        	(LAST_REVIEW_REMARK ,
        	LAST_REVIEW_DATE ,	
        	UPDATE_USER_ID ,
        	UPDATE_USER_NAME ,
        	UPDATE_TIMESTAMP  )
        	  = ( select  
        	  		A.CURRENT_REVIEW_REMARK,  
        	  		A.CURRENT_REVIEW_DATE, 
        	  		A.UPDATE_USER_ID,  
        	  		A.UPDATE_USER_NAME, 
        	  		A.UPDATE_TIMESTAMP  
        	  	from fos.CUSTOMER_ASSET_ALLOCATION B
        	  	where 
        	  		B.customer_number = A.customer_number and B.PRODUCT_INCLUDE_FLAG = A.PRODUCT_INCLUDE_FLAG
        	  		and B.AS_ON_DATE = (select max(C.AS_ON_DATE) 
        	  								from fos.CUSTOMER_ASSET_ALLOCATION  C
        	  								where  
        	  								B.customer_number = C.customer_number and B.PRODUCT_INCLUDE_FLAG = C.PRODUCT_INCLUDE_FLAG)
        	  		)
	where 
	exists(select 1 from fos.CUSTOMER_ASSET_ALLOCATION B where B.customer_number = A.customer_number and B.PRODUCT_INCLUDE_FLAG = A.PRODUCT_INCLUDE_FLAG)	
		; 


**caution: DECIMAL TYPE when integer's width exceed 22 will expose exception
		        and the whole length will not exceed 31

**caution: Image export and import == database backup and restore notice the position of the tablespace and the time and image folder

**caution: Update xxx set (xxx,xxx) = (select yyy,yyy from yyy where zzz)

	   This sql statement will update null to xxx,xxx if the (select yyy,yyy from yyy where zzz) find nothing match

**caution: Primary key should the same with the unique index

-- rebind ----------------------------------------
1. Before you alter the table or compile SP, run below SQL to check which packages is invalid currently

select 'db2 rebind ' || rtrim(pkgschema) || '.' || pkgname from syscat.packages where valid <> 'Y' and pkgschema in ('FOS', 'RPT')

result sample
================
db2 rebind FOS.P8243163

2. execute alter table & compile SP
3. Run the select SQL in Step 1, to check which packages has problem due to your script in Step 2
4. Then rebind the invalid package in db2 command window


=========================================================================================================

Some findings from the views in SYSCAT


(1) SYSCAT.ROUTINES

Contains a row for store proc, retrieved with Sp name.  It contains a field LIB_ID linked to its package name.

e.g.
SELECT SUBSTR(R.ROUTINENAME, 1, 40) ROUTINENAME, R.LIB_ID
FROM SYSCAT.ROUTINES R
WHERE R.ROUTINESCHEMA = 'FOS' AND R.ROUTINENAME LIKE 'PR_CREDIT_EXT_F%'
ORDER BY R.ROUTINENAME

ROUTINENAME                              LIB_ID      
---------------------------------------- ----------- 
PR_CREDIT_EXT_FADERS                     8073794     
PR_CREDIT_EXT_FORWARD_ACCUM              5404500     
PR_CREDIT_EXT_FUTURES                    9554602     
PR_CREDIT_EXT_FX                         4145985     
PR_CREDIT_EXT_FX_PASSPORT                9554683     

 
so, to rebind PR_CREDIT%, use

SELECT 'DB2 REBIND ' || RTRIM(R.ROUTINESCHEMA) || '.P' || RTRIM(CHAR(R.LIB_ID))
FROM SYSCAT.ROUTINES R
WHERE R.ROUTINESCHEMA = 'FOS' AND R.ROUTINENAME LIKE 'PR_CREDIT%'
ORDER BY R.ROUTINENAME


(2) SYSCAT.PACKAGES

Contains info about package such as create time, bind time, etc.  Retrieve by package name which is P + LIB_ID of ROUTINES

SELECT SUBSTR(R.ROUTINENAME, 1, 40) ROUTINENAME, R.LIB_ID, SUBSTR(P.PKGNAME,1,40) PKGNAME, P.LAST_BIND_TIME, P.PKG_CREATE_TIME
FROM SYSCAT.ROUTINES R, SYSCAT.PACKAGES P
WHERE R.ROUTINESCHEMA = 'FOS' AND R.ROUTINENAME LIKE 'PR_CREDIT_EXT_F%'
AND R.ROUTINESCHEMA = P.PKGSCHEMA
AND 'P' || RTRIM(CHAR(R.LIB_ID)) =  P.PKGNAME
ORDER BY R.ROUTINENAME

ROUTINENAME                              LIB_ID      PKGNAME                                  LAST_BIND_TIME             PKG_CREATE_TIME            
---------------------------------------- ----------- ---------------------------------------- -------------------------- -------------------------- 
PR_CREDIT_EXT_FADERS                     8073794     P8073794                                 2006-09-01 18:07:38.083065 2006-09-01 18:07:38.083065 
PR_CREDIT_EXT_FORWARD_ACCUM              5404500     P5404500                                 2007-07-20 09:56:12.662639 2006-10-06 15:40:45.031154 
PR_CREDIT_EXT_FUTURES                    9554602     P9554602                                 2005-10-14 20:33:32.687263 2005-09-26 19:55:46.110780 
PR_CREDIT_EXT_FX                         4145985     P4145985                                 2006-01-25 14:14:59.881287 2006-01-25 14:14:59.881287 
PR_CREDIT_EXT_FX_PASSPORT                9554683     P9554683                                 2006-08-15 17:39:14.146223 2005-09-26 19:55:46.860435 

 
(3) SYSCAT.PACKAGEDEP

Contains info about what table / index / other stored proc, etc, is referenced by a package / store proc

e.g. objects referenced by PR_CREDIT_EXT_FORWARD_ACCUM:

SELECT SUBSTR(R.ROUTINENAME, 1, 40) ROUTINENAME, D.BTYPE,  SUBSTR(D.BNAME,1,40) BNAME
FROM  SYSCAT.ROUTINES R, SYSCAT.PACKAGEDEP D
WHERE R.ROUTINESCHEMA = 'FOS' AND R.ROUTINENAME = 'PR_CREDIT_EXT_FORWARD_ACCUM'
AND R.ROUTINESCHEMA = D.PKGSCHEMA
AND 'P' || RTRIM(CHAR(R.LIB_ID)) =  D.PKGNAME
ORDER BY R.ROUTINENAME, D.BNAME

ROUTINENAME                              BTYPE BNAME                                    
---------------------------------------- ----- ---------------------------------------- 
PR_CREDIT_EXT_FORWARD_ACCUM              T     CREDIT_ASSET_DETAIL                      
PR_CREDIT_EXT_FORWARD_ACCUM              T     CREDIT_EXPOSURE_DETAIL                   
PR_CREDIT_EXT_FORWARD_ACCUM              T     CREDIT_SERVER_MESSAGE                    
PR_CREDIT_EXT_FORWARD_ACCUM              T     CREDIT_SYSTEM_PROPERTY                   
PR_CREDIT_EXT_FORWARD_ACCUM              T     CREDIT_TRANSACTION                       
PR_CREDIT_EXT_FORWARD_ACCUM              T     FAC_DELIVERY_DEAL                        
PR_CREDIT_EXT_FORWARD_ACCUM              T     FAC_POSITION                             
PR_CREDIT_EXT_FORWARD_ACCUM              I     IN_FDLD_01                               
PR_CREDIT_EXT_FORWARD_ACCUM              I     PK_CSPY                                  
PR_CREDIT_EXT_FORWARD_ACCUM              I     PK_FPS                                   
PR_CREDIT_EXT_FORWARD_ACCUM              I     PK_SHIS                                  
PR_CREDIT_EXT_FORWARD_ACCUM              I     PK_SYST                                  
PR_CREDIT_EXT_FORWARD_ACCUM              T     SHARE_ISSUE                              
PR_CREDIT_EXT_FORWARD_ACCUM              T     SYSTEM     

=================================================================================================================================

Some handy SQL based on the info sent to you in my previous mails.

(1) To search which SPs use a particular table:

select RTRIM(R.ROUTINESCHEMA) || '.' || RTRIM(R.ROUTINENAME)  
from SYSCAT.PACKAGEDEP D , SYSCAT.ROUTINES R
WHERE D.BTYPE = 'T' AND D.BNAME = {table_name}
AND SUBSTR(CHAR(R.LIB_ID + 10000000),2,7) = SUBSTR(D.PKGNAME,2,7)
AND D.BSCHEMA = {table schmea}

e.g.

select RTRIM(R.ROUTINESCHEMA) || '.' || RTRIM(R.ROUTINENAME)
from SYSCAT.PACKAGEDEP D , SYSCAT.ROUTINES R
WHERE D.BTYPE = 'T' AND D.BNAME = 'CREDIT_PRODUCT_LENDING'
AND SUBSTR(CHAR(R.LIB_ID + 10000000),2,7) = SUBSTR(D.PKGNAME,2,7)
AND D.BSCHEMA = 'FOS'

returns:
1                                    
-------------------------------------
FOS.PR_CREDIT_RTV_LENDING_T          
FOS.PI_CREDIT_PRODUCT_LENDING        
FOS.PR_API_ZERO_AR_KO_EXP            
FOS.PR_CREDIT_WRITE_CREDITFILES      
FOS.PR_FAC_ZERO_AR_KO_EXP            
FOS.PR_CREDIT_MARK_TO_MKT_V2         
FOS.PR_CREDIT_MARK_TO_MARKET_TUNED   
FOS.PJ_CREDIT_PRODUCT_LENDING        
FOS.PR_CREDIT_RTV_LENDING            
FOS.PR_CREDIT_MARK_TO_MARKET         


(2) To search which SPs call a particular SP

select RTRIM(R1.ROUTINESCHEMA) || '.' || RTRIM(R1.ROUTINENAME)
from SYSCAT.PACKAGEDEP D , SYSCAT.ROUTINES R1, SYSCAT.ROUTINES R2
WHERE D.BTYPE = 'F' AND D.BNAME = R2.SPECIFICNAME AND R2.ROUTINENAME = {stored proc name}
AND D.BSCHEMA = R2.ROUTINESCHEMA
AND SUBSTR(CHAR(R1.LIB_ID + 10000000),2,7) = SUBSTR(D.PKGNAME,2,7)
AND D.BSCHEMA = {stored proc schema}

e.g.

select RTRIM(R1.ROUTINESCHEMA) || '.' || RTRIM(R1.ROUTINENAME)
from SYSCAT.PACKAGEDEP D , SYSCAT.ROUTINES R1, SYSCAT.ROUTINES R2
WHERE D.BTYPE = 'F' AND D.BNAME = R2.SPECIFICNAME AND R2.ROUTINENAME = 'PR_CREDIT_RTV_LENDING'
AND D.BSCHEMA = R2.ROUTINESCHEMA
AND SUBSTR(CHAR(R1.LIB_ID + 10000000),2,7) = SUBSTR(D.PKGNAME,2,7)
AND D.BSCHEMA = 'FOS'

returns:
1                              
-------------------------------
FOS.PR_CREDIT_MARK_TO_MARKET   
FOS.PR_CREDIT_MTM_OTHER        
FOS.PR_CREDIT_OUT_SECFLOAT     
FOS.PR_CREDIT_MARK_TO_MKT_V2   
FOS.PR_TEST_RTV_LEND_OLD       
FOS.PR_CREDIT_REPLACEMENT      
FOS.PR_CREDIT_RTV_DISC         
FOS.PR_CREDIT_RTV_MARGIN       
FOS.PR_CREDIT_FX_HEDGE         
FOS.PR_CREDIT_GET_PARAMETER    
FOS.PR_CREDIT_LOADCONC         
   
-- DB2 Event Monitor ----------------------------------------

2.1 Create and start Event Monitor
a) Connect to the target database
db2 =>connect to DBNAME user USERNAME using PASSWORD

b) Create new Event Monitor
db2 =>create Event Monitor ev2 for statements write to file 'D:\temp' append 
Note1: The output target folder like “D:\temp” is one existing folder in the DB2 server, not the local PC.
Note 2: Files starting from "00000000.EVT" will be created in folder "D:\temp". 
Note 3: If you want to overwrite the existing Event Monitor result files, use "replace" instead of "append".

c) Activate the Event Monitor
db2 =>set event monitor ev2 state 1

2.2	Gather monitor result
a)	Run the application or execute the SQLs in this database

b)	Flush and write the results
db2 =>flush event monitor ev2

c)	Generate output file
Login the DB2 server and access the folder to store the output results (e.g., “D:\temp”).
D:\temp>db2evmon -db P4FRPFOS -evm ev2 > 1.out

File “1.out” will be created in "D:\temp" folder in DB2 server with detailed event results.

d)	Analyze the output
Please refer to Appendix 1 for the sample output of Event Monitor

Useful information:
1)	Text – The SQL text being executed
2)	Start Time – The time this SQL starting to be executed
3)	Stop Time – The time this SQL finishes its execution
4)	Exec Time – Total time of this SQL’s execution
5)	Rows Read – The total number of records got from this SQL

2.3	Stop and drop Event Monitor
a)	Stop the Event Monitor
db2 =>Set event monitor ev2 state = 0 

b)	Drop the Event Monitor
db2 =>drop event monitor ev2 

2.4	Typical usage
a)	Collect all the SQLs written in the existing application
b)	Identify the slowest SQL during the application running, for future performance tuning
c)	Identify the total number of DB access (SQL execution) in one application processing.

2.5	Check DB deadlock
Sample command:
   CREATE EVENT MONITOR DEADLOCK_EVTS
     FOR DEADLOCKS
     WRITE TO FILE 'D:\temp'
     MAXFILES 1
     MAXFILESIZE NONE
     AUTOSTART

db2evmon -db dbname -evm DB2DETAILDEADLOCK
or
db2evmon -path path

2.6	Reference

http://publib.boulder.ibm.com/infocenter/db2luw/v9/topic/com.ibm.db2.udb.admin.doc/doc/r0000915.htm 
2.7	get snapshot
Enable snapshot monitor
db2 get dbm cfg
db2 get dbm cfg|findstr /I mon
db2 update dbm cfg using para_name ON para_name ON para_name ON …

Enable snapshot monitor in different instance
db2ilist
set db2instance=inst_name
db2 get instance
db2 get dbm cfg|findstr /I mon

db2 "list application show detail"
db2 "get snapshot for database manager"
db2 "get snapshot for all on %DB2DATABASE%"
db2 "get snapshot for applications on %DB2DATABASE%"
db2 "get snapshot for tables on %DB2DATABASE%" 
db2 "get snapshot for tablespaces on %DB2DATABASE%"
db2 "get snapshot for locks on %DB2DATABASE%" 
db2 "get snapshot for bufferpools on %DB2DATABASE%" 
db2 "get snapshot for dynamic sql on %DB2DATABASE%"
 
SQL Performance Analyzing

Tool – SQL Explain

3.1 Sample Command
db2expln –d DBNAME –u USERNAME PASSWORD –t –g –q “STAMENT”

Note: It’s better to run RUNSTAT command on the tables before running this command, to get the most accurate results.

3.2 Analyze the result
Please refer to Appendix 2 for the sample output of SQL Explain results

Note: If “TBSCAN” is found in the SQL, DB index needs to be created for this SQL to avoid any table scan.

3.3 Typical usage
a)	Identify potential table scan in the SQL
b)	Compare the SQL performance difference under different index setup.

3.4 Reference
http://publib.boulder.ibm.com/infocenter/db2luw/v8/index.jsp?topic=/com.ibm.db2.udb.doc/core/r0005736.htm

DB2 Explains Itself: A Roadmap to Faster Query Runtime
http://www.devx.com/getHelpOn/10MinuteSolution/16567/1954

4	SQL Performance Tuning
Tool – Design Advisor

4.1 Sample command
Access the DB2 server and run the command on the DB2 server:
a) For single SQL
db2advis –d DBNAME –a USERNAME / PASSWORD –s “STATEMENT”

b) For a set of SQLs
db2advis –d DBNAME –a USERNAME / PASSWORD –i FILENAME

4.2 Analyze the results
Please refer to Appendix 3 for the sample output of Design Advisor

The results will provide some recommendations on the table(s) for improving the performance of the SQL, e.g., create a new index, remove obsolete index, etc. Also the results will show the possible improvement after using the recommendations.

4.3 Typical usage
It’s useful in order to provide suggestions for DB index creation. And it can be used after running the SQL Explain to add index on the table having table scan issue.

4.4 Reference
http://publib.boulder.ibm.com/infocenter/db2luw/v8/index.jsp?topic=/com.ibm.db2.udb.doc/core/r0002452.htm

-- How to Share Data Between Stored Procedures ----------------------------------------
http://www.sommarskog.se/share_data.html

OUTPUT Parameters
This method can only be used when the result set is one single row. Nevertheless, this is a method that is sometimes overlooked. Say you have this simple stored procedure:

CREATE PROCEDURE insert_customer @name    nvarchar(50),
                                 @address nvarchar(50),
                                 @city    nvarchar(50) AS
DECLARE @cust_id int
BEGIN TRANSACTION
SELECT @cust_id = coalesce(MAX(cust_id), 0) + 1 FROM customers (UPDLOCK)
INSERT customers (cust_id, name, address, city)
   VALUES (@cust_id, @name, @address, @city)
COMMIT TRANSACTION
SELECT @cust_id
That is, the procedure inserts a row into a table, and returns the id for the row. 
Rewrite this procedure as:

CREATE PROCEDURE insert_customer @name    nvarchar(50),
                                 @address nvarchar(50),
                                 @city    nvarchar(50),
                                 @cust_id int OUTPUT AS
BEGIN TRANSACTION
SELECT @cust_id = coalesce(MAX(cust_id), 0) + 1 FROM customers (UPDLOCK)
INSERT customers (cust_id, name, address, city)
   VALUES (@cust_id, @name, @address, @city)
COMMIT TRANSACTION
You can now easily call insert_customer from another stored procedure. Just recall that in T-SQL you need to specify the OUTPUT keyword also in the call: 

EXEC insert_customer @name, @address, @city, @cust_id OUTPUT
Note: this example has a single output parameter, but a stored procedure can have many output parameters.

If you take this path, you need to learn how to use OUTPUT parameters with your client API. As this is not a text on client programming, I leave it to the reader to explore how to do that. I let suffice to say that whichever client library you are using, it can be done. I also like to add that using OUTPUT parameters rather than result sets (where this is possible) results in simpler client code, as you don't have to open recordsets and that. You can also expect better performance, although it is only likely to exhibit if you run a tight loop and call the same procedure all over again. 

Table-valued User-defined Functions
User-defined functions were introduced in SQL 2000 and there are in fact three kinds of them: 1) scalar functions 2) inline table-valued functions. 3) multi-statement table-valued functions. It is only the latter two that are of interest here.

I am not going to give an in-depth description of user-defined functions, but just give some quick examples. For full details, please see the CREATE FUNCTION topic in Books Online.

Table-valued functions are far more generally applicable than output parameters, but as we shall see, there are still quite a few restrictions, so there are situations where you cannot use them.

Inline Functions
Here is a example of an inline function taken from Books Online: 

CREATE FUNCTION SalesByStore (@storeid varchar(30))
RETURNS TABLE AS
RETURN (SELECT title, qty
        FROM   sales s, titles t
        WHERE  s.stor_id  = @storeid and
               t.title_id = s.title_id)
To use it, you simply say: 
SELECT * FROM SalesByStore('6380')
That is, you use it just like was a table or a view. Inline functions are indeed much like a parameterized view, because the query optimizer expands the function as if it was a macro, and generates the plan as if you had provided the expanded query. Thus, there is no performance cost for packaging a SELECT statement into a table-valued function. For this reason, when you want to reuse a stored procedure that consists of a single SELECT statement, rewriting it into an inline UDF is without doubt the best choice. (Or instead of rewriting it, move the SELECT into a UDF, and rewrite the existing procedure as a wrapper on the function, so that the client is unaffected.) 
When you are on SQL 2000, there is one restriction, though: you cannot use system functions that are nondeterministic, that is they do not return the same value for the same input parameters on each call. A typical example is getdate(). This restriction has been lifted in SQL 2005.

-- rollforward to the latest log after restore ----------------------------------------
db2 restore db SPESTM1 from d:\DB2Backup TAKEN AT 20060802231245 DBPATH on e: into SPESTM1 replace existing

// cpy those tx logs into SQLOGDIR
db2 rollforward db SPESTM1 to end of logs and complete


// chk the 1st file required for roll forward
db2 rollforward db sample query status

-- reorg ----------------------------------------
db2 reorgchk current statistics on table fos.SHARE_CCASS_TRANSACTION_export > stats1.txt
db2 reorg table fos.ACCOUNT_PRIVILEGE
db2 reorg INDEXES ALL FOR TABLE FOS.POSTING_RECORD
db2 runstats on table FOS.POSTING_RECORD with distribution and detailed indexes all
  
create index FOS.IN_DEPO_REV on FOS.DEPOSIT_DEAL (DEAL_REVERSAL_FLAG);

db2 runstats on table FOS.POSTING_RECORD with distribution and detailed indexes all

db2expln -d QAHKEFOS -g -i -u fos republic -o expln.out -q  "SELECT DD.* from FOS.DEPOSIT_DEAL DD, FOS.CURRENCY C where DD.CUSTOMER_NUMBER = '8018607705' AND DD.SUB_ACCOUNT_NUMBER = '0001' and DD.DEAL_TYPE = '01' and DD.ACTIVE_FLAG = 'A' and DD.DEAL_REVERSAL_FLAG <> 'Y' and DD.LINK_DEAL_NUMBER = 0 and DD.DEPOSIT_MATURITY_FLAG <> 'Y' and DD.DEPOSIT_MATURITY_DATE IS NOT NULL and DD.DEPOSIT_CURRENCY_CODE = C.CURRENCY_CODE and C.ACTIVE_FLAG = 'A' and DD.DEPOSIT_MATURITY_DATE <= C.SETTLE_EVENT_DATE "

-- store procedure ----------------------------------------
--   declare
    /******************************************
     * declare variables
     *****************************************/
    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';
    DECLARE PS_ERROR_MESSAGE VARCHAR(300);

    --variable for specific SQLSTATE
    declare cleanup condition for sqlstate '99000';
    
    /******************************************
     * declare exit HANDLER
     *****************************************/
    --ERROR logger, log errors if failed
    begin
    	DECLARE exit HANDLER FOR SQLEXCEPTION
	    BEGIN GET DIAGNOSTICS EXCEPTION 1 PS_ERROR_MESSAGE = MESSAGE_TEXT;
	        IF (SUBSTR(PS_ERROR_MESSAGE, 1, 8) != 'SQL0438N') THEN
	            CALL FOS.PR_ADD_DAILY_DOWNLOAD_LOG('E', 'PI_CASHIER_1: '||PS_ERROR_MESSAGE);
	            COMMIT;
	        END IF;
	        RESIGNAL SQLSTATE '88888';
    	END;
    end;
    
    --declare cleanup condition for sqlstate '99000', drop table if sql state is '99000'
    declare exit handler FOR cleanup -- equals :declare exit handler for sqlstate '99000'
    begin
        drop table session.TMP_CASHIER_POSITION;
        drop table session.TMP_SD_DUP_DDACC;
    end;

    declare exit handler for SQLEXCEPTION
    begin
        resignal cleanup set message_text = '';
    end;
    /******************************************
     * declare continue handler
     *****************************************/
    --delete records if SQLSTATE is '42710'
    begin
    	declare continue handler for SQLSTATE '42710'
    	begin
    		DECLARE v_dynSQL Varchar(1000);
    		SET v_dynSQL = 'delete from session.TMP_GETDEALT_CASHIER_DEAL';
    		EXECUTE IMMEDIATE v_dynSQL;
    	end;
    end;
    
    -- execute dynamic sql
    begin
        DECLARE v_dynSQL Varchar(1000);
        SET v_dynSQL = 'delete from session.TMP_GETDEALT_CASHIER_DEAL';
        EXECUTE IMMEDIATE v_dynSQL;
    end;        
    --set value if record not found
    declare continue handler for sqlstate '02000' set lc_EOF = 'Y';
    /******************************************
     * declare temp table TMP_CASHIER_POSITION
     *****************************************/

    declare global temporary table TMP_CASHIER_POSITION 
    (
    ACTIVE_FLAG char(1) not null,
    CUSTOMER_NUMBER varchar(12) not null,
    SUB_ACCOUNT_NUMBER varchar(8) not null
    )
    on commit preserve rows
    not logged;
    
    create index session.ind_tcp on session.TMP_CASHIER_POSITION(CUSTOMER_NUMBER);

--resignal

--signal

--  excute 动态 sql(dynamic sql)
    两种方案：                                                
    1、用immediate，                                          
    declare   Mysql   varchar(1024);                          
    set       Mysql   = "update   tablename   set   fd1=xx "; 
    EXECUTE   IMMEDIATE   Mysql;                              
    2、用prepare                                              
    declare   Mysql   varchar(1024);                          
    set       Mysql   = "update   tablename   set   fd1=xx "; 
    prepare   str1   from   Mysql;                            
    EXECUTE   IMMEDIATE   str1;    
    3、带参数
    set stmt = 'delete from ?';                                                  
    --使用prepare语句为这个语句生成存取方案               
    prepare prep_stmt from stmt;                      
    --使用execute语句执行动态sql语句                      
    execute prep_stmt using ods_table;                                                                      
                                                          
    set stmt = 'insert into ? ' || 'select * from ?';               
    --使用prepare语句为这个语句生成存取方案               
    prepare prep_stmt from stmt;                      
    --使用execute语句执行动态sql语句                      
    execute prep_stmt using ods_table, odd_table;     
    
    用变量来代替       
    declare   input_tablename   varchar(1024); 
    ...                                    
    set your_table=input_tablename;       
    set stmt='insert into ' ||  your_table || 'select * from ' || your_table;
    prepare s1 from stme;                 
    execute s1;                           
	
---example
CREATE PROCEDURE FOS.PI_BLACKLIST (  )
LANGUAGE SQL

BEGIN

    DECLARE cc_active_flag CHAR(1);
    DECLARE ls_black_key VARCHAR(22);
    DECLARE ldt_input_date Date;
    DECLARE cs_source_code VARCHAR(16);
    DECLARE cs_internal_code VARCHAR(16);
    DECLARE ls_black_list_name VARCHAR(250);
    DECLARE cs_other_number VARCHAR(250);
    DECLARE cs_passport VARCHAR(250);
    DECLARE cs_address VARCHAR(250);
    DECLARE ldt_effective_date Date;
    DECLARE ldt_expired_date Date;
    DECLARE ls_remark VARCHAR(48);  --the length equals v7nar1 || v7nar2 
    DECLARE cs_access_control VARCHAR(5);
    
    DECLARE ls_dummy CHAR(8);
    DECLARE ls_v7idty VARCHAR(1);
    DECLARE ls_v7idno VARCHAR(20);
    DECLARE ls_v7mdfl VARCHAR(1);
    DECLARE ls_v7nar1 CHAR(24);
    DECLARE ls_v7nar2 CHAR(24);
    DECLARE ld_v7dtad DEC(8);
    DECLARE ld_v7blex DEC(8);
    DECLARE ld_counter Integer;
    
    DECLARE lc_notFound CHAR(1) DEFAULT 'N';
    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';
    DECLARE PS_ERROR_MESSAGE VARCHAR(300);
    DECLARE not_found condition FOR SQLSTATE '02000';
    DECLARE CONTINUE HANDLER FOR not_found SET lc_notFound = 'Y';

    --ERROR logger
    DECLARE exit HANDLER FOR SQLEXCEPTION
	BEGIN GET DIAGNOSTICS EXCEPTION 1 PS_ERROR_MESSAGE = MESSAGE_TEXT;
	        IF (SUBSTR(PS_ERROR_MESSAGE, 1, 8) != 'SQL0438N') THEN
	            CALL FOS.PR_ADD_DAILY_DOWNLOAD_LOG('E', 'PI_OFFICER: '||PS_ERROR_MESSAGE);
	            COMMIT;
	        END IF;
	        RESIGNAL SQLSTATE '88888';
    END;
    
    DELETE FROM FOS.BLACK_LIST;
    SET cc_active_flag = 'A';
    SET cs_source_code = 'HUB';
    SET cs_access_control = 'GLO';
    SET cs_internal_code = '';
    SET cs_other_number = '';
    SET cs_passport = '';
    SET cs_address = '';
    SET ld_counter = 1;
    begin
        declare hub_cursor cursor for
            select V7IDTY,V7IDNO,V7MDFL,V7DTAD,V7CSFN,V7BLEX,RTRIM(V7NAR1),RTRIM(V7NAR2) from HUB.SSBKLSPH 
            for read only;
    
        open hub_cursor;
            SET lc_notFound = 'N';
            fetch from hub_cursor into ls_v7idty,ls_v7idno,ls_v7mdfl,ld_v7dtad,ls_black_list_name,ld_v7blex,ls_v7nar1,ls_v7nar2;
        
            while (lc_notFound = 'N') do           
                SET ls_dummy = left(char(ld_v7dtad),8);
                SET ldt_input_date = date(substr(ls_dummy,1,4)||'-'||substr(ls_dummy,5,2)||'-'||substr(ls_dummy,7,2));  
                SET ls_dummy = left(char(ld_v7blex),8);
                SET ldt_expired_date = date(substr(ls_dummy,1,4)||'-'||substr(ls_dummy,5,2)||'-'||substr(ls_dummy,7,2));   
                SET ldt_effective_date = ldt_input_date;
                SET ls_black_key = char(ld_counter);
                SET ls_remark = ls_v7nar1 || ' ' ||ls_v7nar2;
            	
                INSERT INTO FOS.BLACK_LIST VALUES(cc_active_flag, ls_black_key, ldt_input_date, cs_source_code, cs_internal_code, ls_black_list_name, cs_other_number, cs_passport, cs_address, ldt_effective_date, ldt_expired_date, ls_remark,cs_access_control);
                
                SET lc_notFound = 'N';
                fetch from hub_cursor into ls_v7idty,ls_v7idno,ls_v7mdfl,ld_v7dtad,ls_black_list_name,ld_v7blex,ls_v7nar1,ls_v7nar2;
                SET ld_counter = ld_counter + 1;
            end while;
        close hub_cursor;   	
    end;     	
END  
@