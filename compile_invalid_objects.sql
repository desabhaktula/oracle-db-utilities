--This script compiles invalid objects in a particular schema
-- Make this script accept schema name to make it dynamic

Spool compiles_invalid_objects.lst
Set Echo On Termout On Feedback On;
Set Define off
Set timing on time on serveroutput on size unlimited pages 9999 lines 150

Alter Session Set CURRENT_SCHEMA=MY_SCHEMA;

Begin
    Dbms_Output.Put_Line('List of Invalid Objects before compiling');
    For all_procs In (
                      Select 'Alter '||Object_Type||' '||Object_Name||' Compile' r_sql,
                              Object_Type||' '||Owner||','||Object_Name obj
                      From All_Objects
                      Where Owner = 'MY_SCHEMA'
                      And Status <> 'VALID'
                      And Object_Type != 'PACKAGE BODY'
                      Order By Object_Type, Object_Name
    
    ) Loop
    Begin
        Execute Immediate all_procs.r_sql;
        Dbms_Output.Put_Line('Compiling '||all_procs.obj);
    Exception
        When Others Then
        Dbms_Output.Put_Line('Error While Compiling '||all_procs.obj||'. '||SQLERRM);
    End;
    End Loop;

    -- Compiling Body after specification is compiled
    For all_pkg_body In (
                        Select 'Alter Package '||Object_Name||' Compile Body ' r_sql,
                                Object_Type||' '||Owner||','||Object_Name obj
                        From All_Objects
                        Where Owner = 'MY_SCHEMA'
                        And Status <> 'VALID'
                        And Object_Type = 'PACKAGE BODY'
                        Order By Object_Type, Object_Name 
    ) Loop
    Begin
        Execute Immediate all_pkg_body.r_sql;
        Dbms_Output.Put_Line('Compiling '||all_pkg_body.obj);
    Exception
        When Others Then
        Dbms_Output.Put_Line('Error While Compiling Package Body '||all_pkg_body.obj||'. '||SQLERRM);
    End;
    End Loop;
    
    --Compile any dependent public synonyms
    For all_pub_syn In (
                        Select 'Create Or Replace Public Synonym '||Synonym_Name||' For '||Table_Owner||'.'||Synonym_Name r_sql
                               ,Table_Owner, Synonym_Name
                        From All_Synonyms
                        Where Owner In ('PUBLIC')
                        And   Table_Owner In ('MY_SCHEMA')
                        And   (Owner, Synonym_Name)
                              In (Select Owner, Object_Name 
                                  From ALl_Objects Where Object_Type = 'SYNONYM'
                                  And  Status <> 'VALID')
                        Order By Table_Owner, Synonym_Name
    ) Loop
    Begin
        Execute Immediate all_pub_syn.r_sql;
    Exception
        When Others Then
        Dbms_Output.Put_Line('  Public Synonym For '||all_pub_syn.Table_Owner||'.'||all_pub_syn.Synonym_Name r_sql||' Is Invalid. '||SQLERRM);
    End;
    End Loop;
    
End;
/

spool off

    