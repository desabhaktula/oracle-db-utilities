--Where there is no access to system views like v$instance etc.

-- Query for Database version number
Select * From Product_Component_Version;


-- In PDB(Pluggable DB) and CDB(Container DB) instances, DB name will be different from Instance name and so on
-- more over we can have different service names for same db name
Select SYS_CONTEXT('USERENV','SERVICE_NAME') Service_Name
      ,SYS_CONTEXT('USERENV','CDB_NAME') CDB_Name
      ,SYS_CONTEXT('USERENV','DB_NAME') CDB_Instance_Name
      ,SYS_CONTEXT('USERENV','SERVER_HOST') Host_Node_Name
      ,SYS_CONTEXT('USERENV','CON_NAME') DB_Name
      ,SYS_CONTEXT('USERENV','INSTANCE_NAME') Intance_Node_Name
From Dual;

-- Service Names for the DB will be created for databases, to check all available service names
-- have to find a work around query for this
Select * From all_services;
