-- script to increment the sequence nextvalue to be in synch with the table it is used in

Set Serveroutput On Size Unl;
Declare
    Error_Code   NUMBER;
    Error_Msg    Varchar2(32727);
    L_Max_ID     Number;
    L_Sql        Varchar2(32727);
    L_Next_Val   Number;
    L_Diff_Val   Number;
    L_Seq_Name   Varchar2(128);
Begin
    Select Max(ID) Into L_Max_ID
    From   Schema.Table_Name;
    
    L_Seq_Name := "Schema.Sequence_Name";
    Dbms_OutPut.Put_Line('Sequence '||L_Seq_Name||' Should Start with '||L_Max_ID);
    
    L_Next_Val := Schema.Sequence_Name.NextVal;
    
    If L_Next_Val < L_Max_ID Then 
        L_Diff_Val := L_Max_ID - L_Next_Val;
        
        L_Sql := 'Alter Sequence '||L_Seq_Name||' Increment By '||L_Diff_Val;
        Execute Immediate L_Sql;
        L_Next_Val := Schema.Sequence_Name.NextVal;
        
        L_Sql := 'Alter Sequence '||L_Seq_Name||' Increment By 1';-- If the increment value is other than 1, change this line accordingly
        Execute Immediate L_Sql;
        Dbms_OutPut.Put_Line('Sequence '||L_Seq_Name||' CurrValue is set to '||L_Next_Val);
    Else
        Dbms_OutPut.Put_Line('Sequence '||L_Seq_Name||' CurrValue('||L_Next_Val||') is already greater than Max ID '||L_Max_ID);
    End If;
    
Exception
    When Others Then
        Rollback;
        Error_Code := SQLCODE;
        Error_Msg  := 'Error While Resetting  sequence'||L_Seq_Name||' - '||
                      ||Dbms_Utility.Format_Error_Backtrace()
                      ||' '
                      ||SQLERRM;
        Dbms_OutPut.Put_Line(Error_Code);
        Dbms_OutPut.Put_Line(Error_Msg);
End;
/


---------------------------------------------------------------------------------------------------
-- Set Sequences which have increment by value other than 1 , to 1

Set Serveroutput On Size Unl;
Begin
    For seq In (Select * From All_Sequences
                Where  Sequence_Owner = 'MY_SCHEMA'
                And    Increment_By <> 1
                Order By Sequence_Name;
                )
    Loop
        Execute Immediate 'Alter Sequence '||seq.Sequence_Owner||'.'||seq.Sequence_Name||'  Increment By 1';
        Dbms_OutPut.Put_Line(seq.Sequence_Owner||'.'||seq.Sequence_Name||' Altered');
    End Loop;
End;
/