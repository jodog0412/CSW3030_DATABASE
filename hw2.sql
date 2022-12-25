create table campaign 
(CAMPAIGN_NUMBER char(5) NOT NULL,
BUDGET integer,
primary key (CAMPAIGN_NUMBER));
insert into campaign values ('C-101',500);
insert into campaign values ('C-102',400);
insert into campaign values ('C-103',900);
insert into campaign values ('C-104',700);
insert into campaign values ('C-105',750);
insert into campaign values ('C-106',700);
insert into campaign values ('C-107',350);

select * from campaign;

create table person 
(PERSON_NAME char(15) NOT NULL,
PERSON_STREET char(15),
PERSON_CITY char(15),
primary key (PERSON_NAME));
insert into person values ('Adams','Spring','Pittsfield');
insert into person values ('Brooks','Senator','Brooklyn');
insert into person values ('Curry','North','Rye');
insert into person values ('Glenn','Sand Hill','Woodside');
insert into person values ('Green','Walnut','Stamford');
insert into person values ('Hayes','Main','Harrison');
insert into person values ('Johnson','Alma','Palo Alto');
insert into person values ('Jones','Main','Harrison');
insert into person values ('Lindsay','Park','Pittsfield');
insert into person values ('Smith','North','Rye');
insert into person values ('Turner','Putnam','Stamford');
insert into person values ('Williams','Nassau','Princeton');

select * from person;
create table adgroup
(GROUP_NUMBER char(9) NOT NULL,
CAMPAIGN_NUMBER char(5),
TARGET_MIN_AGE integer,
TARGET_MAX_AGE integer,
primary key (GROUP_NUMBER,CAMPAIGN_NUMBER),
foreign key (CAMPAIGN_NUMBER) references campaign (CAMPAIGN_NUMBER) on delete cascade);
insert into adgroup values ('GROUP-101','C-101',10,19);
insert into adgroup values ('GROUP-102','C-101',10,39);
insert into adgroup values ('GROUP-103','C-102',20,29);
insert into adgroup values ('GROUP-104','C-103',30,59);
insert into adgroup values ('GROUP-105','C-104',40,69);
insert into adgroup values ('GROUP-106','C-104',10,29);
insert into adgroup values ('GROUP-107','C-107',40,49);
select * from adgroup;

create table advertise
(CAMPAIGN_NUMBER char(5),
PERSON_NAME char(15),
foreign key (CAMPAIGN_NUMBER) references campaign (CAMPAIGN_NUMBER) on delete cascade);
insert into advertise values ('C-101','Adams');
insert into advertise values ('C-102','Curry');
insert into advertise values ('C-103','Johnson');
insert into advertise values ('C-104','Johnson');
insert into advertise values ('C-105','Smith');
insert into advertise values ('C-106','Wiliams');
insert into advertise values ('C-107','Hayes');
select * from advertise;

create table ad
(AD_NUMBER char(5),
GROUP_NUMBER char(9),
AD_TYPE char(5),
primary key (AD_NUMBER,GROUP_NUMBER),
foreign key (GROUP_NUMBER) references adgroup (GROUP_NUMBER) on delete cascade);
insert into ad values ('AD-11','GROUP-101','Image');
insert into ad values ('AD-12','GROUP-101','Image');
insert into ad values ('AD-13','GROUP-102','Video');
insert into ad values ('AD-14','GROUP-104','Image');
insert into ad values ('AD-15','GROUP-104','Video');
insert into ad values ('AD-16','GROUP-104','Video');
insert into ad values ('AD-17','GROUP-107','Image');
select * from ad;

create table myview
(AD_NUMBER char(5),
PERSON_NAME char(15),
primary key (AD_NUMBER,PERSON_NAME),
foreign key (AD_NUMBER) references ad (AD_NUMBER) on delete cascade,
foreign key (PERSON_NAME) references person (PERSON_NAME) on delete cascade);
insert into myview values ('AD-11','Brooks');
insert into myview values ('AD-11','Curry');
insert into myview values ('AD-13','Johnson');
insert into myview values ('AD-14','Brooks');
insert into myview values ('AD-16','Smith');
insert into myview values ('AD-16','Lindsay');
insert into myview values ('AD-16','Turner');
insert into myview values ('AD-13','Glenn');
insert into myview values ('AD-12','Green');
select * from myview;

select distinct CAMPAIGN_NUMBER from adgroup;

select distinct PERSON_NAME
from myview
where AD_NUMBER=any(select AD_NUMBER from ad where GROUP_NUMBER=any(select GROUP_NUMBER from adgroup where CAMPAIGN_NUMBER='C-101'));

select distinct PERSON_NAME from myview
union
select distinct PERSON_NAME from advertise;

select distinct myview.PERSON_NAME from myview
inner join advertise on (advertise.PERSON_NAME=myview.PERSON_NAME);


select * 
from campaign
natural join adgroup
where CAMPAIGN_NUMBER in (select CAMPAIGN_NUMBER from adgroup where TARGET_MIN_AGE<21 and TARGET_MAX_AGE>28);

select distinct PERSON_NAME 
from myview
where PERSON_NAME not in (select PERSON_NAME from advertise);

select GROUP_NUMBER, CAMPAIGN_NUMBER
from adgroup
where GROUP_NUMBER in
(select GROUP_NUMBER 
from adgroup
where GROUP_NUMBER in (select GROUP_NUMBER from ad));

select CAMPAIGN_NUMBER, PERSON_NAME
from ad
natural join myview
natural join adgroup;

select * 
from campaign
natural join adgroup
where CAMPAIGN_NUMBER in (select CAMPAIGN_NUMBER from adgroup where TARGET_MAX_AGE<30);

select CAMPAIGN_NUMBER,AD_NUMBER,GROUP_NUMBER,AD_TYPE
from ad
natural join adgroup
where AD_NUMBER in (select AD_NUMBER
from myview
where PERSON_NAME in (select PERSON_NAME
from person
where PERSON_CITY='Stamford'));

select AD_NUMBER
from myview
where PERSON_NAME in (select PERSON_NAME
from person
where PERSON_CITY='Stamford');

select *
from advertise
where PERSON_NAME in (select PERSON_NAME
from person
where PERSON_STREET like 'N%');

create view all_customer as 
(select *
from advertise)
union
(select CAMPAIGN_NUMBER, PERSON_NAME
from ad
natural join myview
natural join adgroup)
order by CAMPAIGN_NUMBER;

select * from all_customer;

select PERSON_NAME
from all_customer
where PERSON_NAME in (select PERSON_NAME from person where PERSON_CITY='Harrison');

select distinct CAMPAIGN_NUMBER
from adgroup
where GROUP_NUMBER in 
(select distinct GROUP_NUMBER from ad where AD_TYPE='Video' 
and 
GROUP_NUMBER in (select GROUP_NUMBER from ad where AD_TYPE='Image'));

select distinct CAMPAIGN_NUMBER
from adgroup
where GROUP_NUMBER in 
(select distinct GROUP_NUMBER from ad where GROUP_NUMBER!=
(select distinct GROUP_NUMBER from ad where AD_TYPE='Video' 
and 
GROUP_NUMBER in (select GROUP_NUMBER from ad where AD_TYPE='Image')));