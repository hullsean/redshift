
--
-- Redshift is a little tricky when it comes to grant syntax.
-- It's close to standard SQL, but with some tweaks.
-- Here are some examples.
-- 
-- Note when you revoke privs you have to remove them from
-- "public" or the user will still have access.  That's a little
-- counterintuitive.
--
-- Also there is the concept of a database *AND* a schema.  This
-- is different from other platforms like Oracle & MySQL.  They mean
-- something else here.
-- In Redshift:
--   DATABASE - is a logical grouping which contains schemas
--            - You cannot query across db1.obj, db2.obj.
--            - Objects in other databases are not accessible.
--            - Even strangely as root.  Unless you connect first
--            - to that other database
--  
--   SCHEMA   - is a logical grouping of objects.  You can have
--            - multiple schemas, and you *CAN* query across them
--        EX: SELECT ta.a, tb.a FROM s1.tablea ta, s2.tableb tb
--            WHERE ta.c1 = tb.c1;
--
--

create group readonly;
create group readcreate;

create user ashley with password 'abc';

-- ashley user gets readonly permissions
alter group readonly  add user ashley;

-- arthur gets read/write permissions
alter group readcreate add user arthur;


-- remove default permissions on public
REVOKE CREATE ON SCHEMA public FROM PUBLIC
revoke select on schema public from public
revoke insert on schema public from public
revoke update on schema public from public
revoke delete on schema public from public
revoke drop on schema public from public
revoke truncate on schema public from public



create database dwh;
create schema dwh.acme;


-- give readcreate group r/w to public
grant usage on schema public to group readcreate;
grant create on schema public to group readcreate;
grant select on all tables in schema public to group readcreate;
grant insert on schema public to group readcreate;

-- give readcreate group r/w to acme
grant usage on schema acme to group readcreate;
grant create on schema acme to group readcreate;
grant select on all tables in schema acme to group readcreate;
grant insert on all tables in schema public to group readcreate;

-- give readonly group select on public & acme
grant usage on schema public to group readonly;
grant select on schema public to group readonly;

grant usage on schema acme to group readonly;
grant select on all tables in schema acme to group readonly;






