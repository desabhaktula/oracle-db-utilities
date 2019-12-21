Set Time On Timing On;
Set ServerOutPut On Size Unl;

Begin
    For ind_part_rec In
                    (Select index_name, partition_name
                           'Alter Index '||Index_Owner||'.'||index_name||' Rebuild Partition '||partition_name||' Parallel NoLogging' sql_stmt
                     From   all_ind_partitions a
                     Where Status <> 'USABLE'
                     And   Index_Name = 'MY_INDEX_01'
                     Order By index_name,partition_name
                    )
    Loop
        Execute Immediate ind_part_rec.sql_stmt;
        Dbms_OutPut.Put_Line('Rebuilding '||ind_part_rec.partition_name||' Completed');
    End Loop;
    Execute Immediate 'Alter Index MY_INDEX_01 NoParallel';
End;
/