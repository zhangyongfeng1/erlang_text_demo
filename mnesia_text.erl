-module(mnesia_text).
% -export([init/0,
% 	create_m_y_account/0,
% 	create_m_y_info/0,
% 	delete_m/0,
% 	select/0,
% 	select_qlc/0,
% 	quary/0,
% 	quary_qlc/0,
% 	write/0,
% 	write_y_info/0,
% 	where_qlc/0,
% 	where/0,
% 	where_qlc_key/0,
% 	where_qlc_no_key/0,
% 	order_by/0,
% 	order_by_two/0,
% 	join/0
% 	]).

-compile([export_all]).%引出本模块所有的方法

-include_lib("stdlib/include/qlc.hrl").

%% 账号表结构   
-record( y_account,{ id, account, password }).  

%% 资料表结构    
-record( y_info, { id, nickname, birthday, sex }). 

init() ->
	%% 在本机节点上初始化数据库	
	mnesia:create_schema([node()]),
	%% 启动数据库
 	mnesia:start().

%1、Create Table / Delete Table 操作
%%===============================================  
%%  create table y_account ( id int, account varchar(50),  
%%   password varchar(50),  primary key(id)) ;  
%%===============================================  
create_m_y_account() ->
 	mnesia:create_table( y_account,[{attributes, record_info(fields, y_account)} , {type,set}, {disc_copies, [node()]} ]). 

create_m_y_info() ->
 	mnesia:create_table( y_info,[{attributes, record_info(fields, y_info)} , {type,set}, {disc_copies, [node()]} ]). 

%%===============================================  
%%  drop table y_account;  
%%=============================================== 
delete_m() ->
	mnesia:delete_table(y_account) .  

%2、Select 查询
select() ->
%% 2.1使用 mnesia:select  
F = fun() ->  
    MatchHead = #y_account{ _ = '_' },  
    Guard = [],  
    Result = ['$_'],  
    mnesia:select(y_account, [{MatchHead, Guard, Result}])  
end,  
mnesia:transaction(F).  

%% 2.2使用 qlc 
%%===============================================  
%%  select * from y_account  
%%===============================================  
select_qlc() -> 
F = fun() ->  
    Q = qlc:q([E || E <- mnesia:table(y_account)]),  
    qlc:e(Q)  
end,  
mnesia:transaction(F). 

% 2.3查询部分字段的记录
%%===============================================  
%%  select id,account from y_account  
%%===============================================  
quary() ->
F = fun() ->  
    MatchHead = #y_account{id = '$1', account = '$2', _ = '_' },  
    Guard = [],  
    Result = ['$$'],  
    mnesia:select(y_account, [{MatchHead, Guard, Result}])  
end,  
mnesia:transaction(F).  

quary_qlc() ->
%% 使用 qlc  
F = fun() ->  
    Q = qlc:q([[E#y_account.id, E#y_account.account] || E <- mnesia:table(y_account)]),  
    qlc:e(Q)  
end,  
mnesia:transaction(F).

%3、Insert / Update 操作
%%===============================================  
%%    insert into y_account (id,account,password) values(5,"xiaohong","123")  
%%     on duplicate key update account="xiaohong",password="123";  
%%===============================================  
%mnesia是根据主键去更新记录的，如果主键不存在则插入
write()->
%% 使用 mnesia:write  
F = fun() ->  
    Acc1 = #y_account{id = 1, account="xiaohong1", password="11"},  
    Acc2 = #y_account{id = 2, account="xiaohong2", password="13"},  
    Acc3 = #y_account{id = 5, account="xiaohong", password="3"},  
    Acc4 = #y_account{id = 6, account="xiaohong6", password="2"},  
    mnesia:write(Acc1),  
    mnesia:write(Acc2),  
    mnesia:write(Acc3),  
    mnesia:write(Acc4)  
end,  
mnesia:transaction(F).  

write_y_info()->
%% 使用 mnesia:write   id, nickname, birthday, sex 
F = fun() ->  
    Acc1 = #y_info{id = 1, nickname="aaa", birthday="20180101"},  
    Acc2 = #y_info{id = 5, nickname="bbb", birthday="20181001"},  
    Acc3 = #y_info{id = 6, nickname="ccc", birthday="20180103"},  
    mnesia:write(Acc1),
    mnesia:write(Acc2),
    mnesia:write(Acc3)
end,  
mnesia:transaction(F).  

%4、Where 查询
%%===============================================  
%%    select account from y_account where id>5  
%%===============================================  
where() ->
%% 使用 mnesia:select  
F = fun() ->  
    MatchHead = #y_account{id = '$1', account = '$2', _ = '_' },  
    Guard = [{'>', '$1', 5}],  
    Result = ['$2'],  
    mnesia:select(y_account, [{MatchHead, Guard, Result}])  
end,  
mnesia:transaction(F).

where_qlc() ->
F = fun() ->  
    Q = qlc:q([E#y_account.account || E <- mnesia:table(y_account), E#y_account.id>5]),  
    qlc:e(Q)  
end,  
mnesia:transaction(F). 
%%===============================================  
%%   select * from y_account where account='xiaomin'  
%%===============================================  
where_qlc_key() ->
%如果查找主键 key=X 的记录，还可以这样子查询：
F = fun() ->  
    mnesia:read({y_account,5})  
end,  
mnesia:transaction(F). 

%%===============================================  
%%   select * from y_account where account='xiaomin'  
%%===============================================  
where_qlc_no_key() ->
%如果查找非主键 field=X 的记录，可以如下查询：
F = fun() ->  
    MatchHead = #y_account{ id = '_', account = "xiaomin", password = '_' },  
    Guard = [],  
    Result = ['$_'],  
    mnesia:select(y_account, [{MatchHead, Guard, Result}])  
end,  
mnesia:transaction(F). 

%5、Order By 查询
%%===============================================  
%%   select * from y_account order by id asc  
%%=============================================== 
order_by(MUN) ->
%% 使用 qlc  
F = fun() ->  
    Q = qlc:q([E || E <- mnesia:table(y_account)]),  
    qlc:e(qlc:keysort(MUN, Q, [{order, ascending}]))  
end,  
mnesia:transaction(F).  

order_by_two()->
%% 使用 qlc 的第二种写法  
F = fun() ->    
    Q = qlc:q([E || E <- mnesia:table(y_account)]),   
    Order = fun(A, B) ->  
        B#y_account.id > A#y_account.id  
    end,  
    qlc:e(qlc:sort(Q, [{order, Order}]))  
end,    
mnesia:transaction(F). 

%6、Join 关联表查询
%%===============================================  
%%   select y_info.* from y_account join y_info on (y_account.id = y_info.id)  
%%      where y_account.account = 'xiaomin'  
%%===============================================  
join() ->
%% 使用 qlc  
F = fun() ->  
    Q = qlc:q([Y || X <- mnesia:table(y_account),  
        X#y_account.account =:= "xiaohong",  
        Y <- mnesia:table(y_info),  
        X#y_account.id =:= Y#y_info.id  
    ]),  
    qlc:e(Q)  
end,  
mnesia:transaction(F).  

%7、limit查询
%%===============================================  
%%   select * from y_account limit 2  
%%=============================================== 
limit() ->
F = fun() ->  
    MatchHead = #y_account{ _ = '_' },   
    mnesia:select(y_account, [{MatchHead, [], ['$_']}], 2, none)  
end,  
mnesia:transaction(F).  

limit_qlc() ->
F = fun() ->  
    Q = qlc:q([E || E <- mnesia:table(y_account)]),  
    QC = qlc:cursor(Q),  
    qlc:next_answers(QC, 2)  
end,  
mnesia:transaction(F).

%8、Select count(*) 查询
%%===============================================  
%%   select count(*) from y_account  
%%===============================================  
select_count() ->
%% 使用 mnesia:table_info  
F = fun() ->  
    mnesia:table_info(y_account, size)  
end,  
mnesia:transaction(F). 

%9、Delete 查询
%%===============================================  
%%   delete from y_account where id=5  
%%===============================================  
delete_data()->
%% 使用 mnesia:delete  
F = fun() ->  
    mnesia:delete({y_account, 5})  
end,  
mnesia:transaction(F). 


