SELECT DBMS_METADATA.get_ddl ('TABLE', table_name) FROM user_tables;
SELECT owner, table_name FROM all_tables;
select TABLE_NAME from user_tables;
select username from dba_users; 
select distinct owner from dba_objects; 
SELECT username FROM all_users;

select dp.name as proj, da.name as app, count(da.name) as app_dep_count 
from deploy_activity_apps daa 
inner join deploy_apps da on daa.fk_app=da.pk_id 
inner join deploy_projects dp on da.fk_project=dp.pk_id 
where live=0 and STATE IN ('Complete','Failed','In Progress') GROUP BY dp.name, da.name order by dp.name;

select * from hosts where rownum < 6;
select * from servers where rownum < 6;
select * from domain_names where rownum < 6;

select s.pk_id,s.name || CASE lower(d.name) WHEN 'no_domain' THEN '' ELSE '.' || d.name END Server, CASE is_change_controlled WHEN 0 THEN 'N' ELSE 'Y' END PROD,
p.name project from hosts s 
left outer join servers ss on ss.fk_name=s.pk_id 
left outer join domain_names d on d.pk_id = ss.fk_domain_name 
left outer join svr_proj_owners spo on ss.pk_id = spo.server_fk
left outer join deploy_projects p on p.pk_id = spo.project_fk
where s.name like '136.57.8.%' or s.name like '136.60.212.%' or s.name like '136.61.212.%' or s.name like 'idc%' or s.name like 'idp%'
order by server;

select * from svr_proj_owners;
select * from repliweb_creds where PK_ID > 1080;
select * from deploy_projects where name = 'G3-HSS-PFS';
select * from deploy_projects where pk_id = 1302;
select * from deploy_apps where FK_PROJECT = 1562;
select * from deploy_apps where name = 'RBP';
select count(1) , mon from (select to_char( sched_start, 'Month' ) as mon  from deploy_activity_apps where sched_start < TO_DATE('2017-06-01 00:00:00', 'yyyy-mm-dd HH24:mi:ss') and sched_start > TO_DATE('2017-01-01 00:00:00', 'yyyy-mm-dd HH24:mi:ss')) GROUP BY mon;
select * from deploy_activity_apps where fk_app = 10909;
select * from deploy_activity_apps where fk_app = 544 and state = 'Pending';
select * from deploy_activity_apps where workflow_id = 1200506  and state = 'Pending';
--update deploy_activity_apps set state = 'Cancelled' where workflow_id = 490414  and state = 'Pending';
--update deploy_activity_apps set state = 'Cancelled' where fk_app = 10909 and state = 'Pending';
--update deploy_tasks set state='Failed', trig='manual' where pk_id = 5374520;
select * from deploy_tasks where FK_DEPLOY_ACTIVITY_APP = 10397;
select * from deploy_tasks where TASK_ID like '1200777-%';
select * from deploy_apps_svrs_props T inner join deploy_apps A on T.FK_APP = A.PK_ID where name = 'CAS-ESD-HTSE' and version = '22963';
select * from deploy_apps_svrs_props where version = '22963';
select * from deploy_app_props where version = '22963';

select * from deploy_activity_apps where deploy_end < TO_DATE('2017-06-01 00:00:00', 'yyyy-mm-dd HH24:mi:ss') and deploy_end > TO_DATE('2017-05-31 23:00:00', 'yyyy-mm-dd HH24:mi:ss') and live = 1;

select count(unique name) from deploy_apps;
--select server and credential info
select 
  h.name, s.loc_id, s.is_change_controlled, d.name as domain_name,
  c.real_user, c.virt_user, c.scr_pwd, c.work_dir, c.pk_id, c.domain
from hosts h
left outer join servers s on s.fk_name = h.pk_id  
left outer join repliweb_creds c on c.fk_server=s.pk_id
left outer join domain_names d on s.fk_domain_name = d.pk_id
where 
  LOWER(h.name) like LOWER('%H00U2148%'); 
  
select max(PK_ID) from repliweb_creds;

--check the current sequence number used in repliweb_creds table
select REPLIWEB_CREDS_ID_SEQ.nextval, REPLIWEB_CREDS_ID_SEQ.CURRVAL from dual; 
--increase the sequence number in repliweb_creds table
select DEPLOY_PROJECTS_ID_SEQ.nextval from dual; 

select row_number() over ( order by h.name ) as rnum, s.pk_id as fk_server,'wasad', 'rw_wasad', 'D847JUDIL9TLDTSD9UUG5UBQK1', '/tmp/repliweb', h.name from hosts h
left outer join servers s on s.fk_name = h.pk_id  
where h.name = '130.47.174';

--insert the credential to the table
insert into repliweb_creds
select rownum + (select max(PK_ID) from repliweb_creds), s.pk_id as fk_server,'wasad', 'rw_wasad', 'D847JUDIL9TLDTSD9UUG5UBQK1', '/tmp/repliweb' from hosts h
left outer join servers s on s.fk_name = h.pk_id  
where h.name in
('hkcb2ls0156o');

--update repliweb_creds set scr_pwd = 'D847JUDIL9TLDTSD9UUG5UBQK1' where PK_ID > 1080 and scr_pwd = 'D847JUDIL9TLDTSD9UUG5UBQ';

--delete from release_locks where RELEASE_ID = '82369';
select * from release_locks where ENV_NAME = 'UAT';
select * from release_locks where RELEASE_ID = '82369';

select 
  h.name, s.loc_id, s.is_change_controlled, d.name as domain_name
from hosts h
left outer join servers s on s.fk_name = h.pk_id  
left outer join domain_names d on s.fk_domain_name = d.pk_id
where 
  h.name in (
   'hkcb2ls0157o'); 

select * from repliweb_creds where real_user = 'release';

--update repliweb_creds set scr_pwd = 'DTy2G5I9Vzj/uwkX2/srAIUPQzF7AO4yoL9IYFO4UwQ=' where real_user = 'release';

--CREATE UNIQUE INDEX packaged_arts_unique_index ON packaged_arts (FK_APP,NAME,VERSION);
select NAME,VERSION,FK_APP,count(1) from packaged_arts GROUP BY NAME, VERSION, FK_APP having count(1) > 1;
select * from packaged_arts where NAME = 'CI_Dashboard'  and version = '0.0.4-SNAPSHOT';
--delete from packaged_arts where pk_id = 540963;
select * from packaged_arts where DATE_PKGD > to_timestamp('01-07-2016 00:00:00', 'dd-mm-yyyy hh24:mi:ss') and (NAME, version,FK_APP) in (select NAME,VERSION,FK_APP from packaged_arts GROUP BY NAME, VERSION, FK_APP having count(1) > 1);
select * from packaged_arts where (pk_id) in (select min(pk_id) from packaged_arts GROUP BY NAME, VERSION, FK_APP having count(1) > 1);
--delete from packaged_arts where (pk_id) in (select min(pk_id) from packaged_arts GROUP BY NAME, VERSION, FK_APP having count(1) > 1);
select * from packaged_arts where (NAME, VERSION, FK_APP) in (select NAME, VERSION, FK_APP from packaged_arts GROUP BY NAME, VERSION, FK_APP having count(1) > 1);
/*insert into packaged_arts select 
PACKAGED_ARTS_ID_SEQ.nextval,
FK_APP,
FK_MVN_ART,
NAME,
VERSION,
PKG_NO,
DATE_PKGD,
CKSUM,
SIZ,
STATUS,
LAST_MOD,
DELETED_DATE from packaged_arts where pk_id = 5045;
delete from packaged_arts where pk_id = 5081 or pk_id = 5082;
alter table DEPLOY_APP_PROPS modify
   (
	PK_ID NUMBER(7, 0),
	FK_APP NUMBER(7, 0)
   );

alter table DEPLOY_APPS_SVRS_PROPS modify
   (
	PK_ID NUMBER(7, 0),
	FK_APP NUMBER(7, 0)
   );
   
alter table DEPLOY_PROJECTS modify
   (
	NAME VARCHAR2(100) 
   );
   
alter table DEPLOY_TASKS modify
   (
	TASK_ID VARCHAR2(75), 
USER_ID VARCHAR2(40), 
TGT_ENTITY VARCHAR2(50)
   );
   
alter table SATELLITES modify
   (
	PK_ID NUMBER(4,	0)
   );
   
alter table PKGD_ART_ON_SATS modify
   (
	SAT_FK NUMBER(4,	0)
   );*/
   
select * from servers;
select * from hosts;
select * from domain_names;
select * from SVR_PROJ_OWNERS;
select * from RELEASE_LOCKS;
select * from DEPLOY_TEMPLATES;
select * from operating_systems;
SELECT * FROM v$version;
select * from DEPLOY_TEMPLATES;
select * from deploy_templates_props;
select DEPLOY_TEMPLATES_ID_SEQ.nextval from dual;
select DEPLOY_TEMPLATES_PROPS_ID_SEQ.nextval from dual;
select * from housekeeping;
select * from housekeeping_job;
select * from housekept_artefact;
select * from satellites;
select * from maven_arts;
select * from deploy_apps;
select * from deploy_projects;
select * from packaged_arts;
select * from provision_status;
select * from provision_step;
select * from environments;

delete from provision_status;
delete from provision_step;
delete from housekeeping;
delete from housekeeping_job;
delete from housekept_artefact;
delete from satellites;
delete from packaged_arts where name = 'My Name';
delete from deploy_apps where name='My Application';
delete from deploy_projects where name='My Project';
delete from maven_arts where name='My name';
delete from servers where pk_id > 73;
delete from hosts where name='My Host';
delete from domain_names where name='My Domain';
delete from operating_systems where name = 'My OS';
delete from SVR_PROJ_OWNERS where server_fk > 73;
delete from DEPLOY_TEMPLATES;
delete from deploy_templates_props;

--Grep the 'In progress' task running in current data for production
SELECT t1.TASK_ID, t1.STATE, t1.TTYPE, t2.SCHED_START FROM DEPLOY_TASKS t1 
INNER JOIN DEPLOY_ACTIVITY_APPS t2
on t1.TASK_ID like CONCAT(t2.WORKFLOW_ID, '%') AND t1.STATE = 'In Progress' AND t2.STATE = 'In Progress' AND  to_char(t2.SCHED_START, 'yyyyMMdd') < to_char(SYSDATE, 'yyyyMMdd')
AND t2.live=1; 