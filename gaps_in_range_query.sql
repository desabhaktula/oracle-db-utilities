/* There is a table with start range number and end range number
 need to find missing ranges
 these ranges might be overlapping or mutually exclusive.

start_ip_num   end_ip_num
1              5
9              12
10             15

in this example 6,7 and 8 are missing. so we need to find that gap
 
*/


create table temp_tbl(start_ip_num number, end_ip_num number) ;
insert into temp_tbl(start_ip_num,  end_ip_num ) values (1,5) ;
insert into temp_tbl(start_ip_num,  end_ip_num ) values (9,12) ;
insert into temp_tbl(start_ip_num,  end_ip_num ) values (10,15) ;
commit;

With all_ip_num As
    (Select rownum rn, start_ip_num,end_ip_num
     From   (Select start_ip_num,end_ip_num From Temp_Tble Order By 1,2)
     )
Select ip1.rn rn1, ip1.start_ip_num start_ip_num1,ip1.end_ip_num end_ip_num1,
       ip2.rn rn2, ip2.start_ip_num start_ip_num2,ip2.end_ip_num end_ip_num2,
       ,(ip2.start_ip_num - ip1.end_ip_num) numbers_in_gap
From   all_ip_num ip1,     
       all_ip_num ip2
Where  ip2.rn = ip1.rn+1
and    (ip2.start_ip_num - ip1.end_ip_num) > 1 ;
