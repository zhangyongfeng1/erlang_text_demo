-module(mns).
-export([init/0,
	queryall/0,
	myinsert/0,
	delete_reco/1,
    reset_table/0]).

-include_lib("stdlib/include/qlc.hrl").

 %% 定义记录结构
-record(todo,{status=reminder,who=joe,text}).
-record(shop,{item,quantity,cost}).
-record(cost,{name,price}).
-record(design,{id,plan}).

%%数据库初始化
init() ->
	%% 在本机节点上初始化数据库	
	mnesia:create_schema([node()]),
	%% 启动数据库
 	mnesia:start(),
	%% 创建表 获取记录的字段信息
	mnesia:create_table(todo,[{attributes,record_info(fields,todo)}]),
    %% 创建shop表
    mnesia:create_table(shop,[{attributes,record_info(fields,shop)}]), 
    %% 创建cost表
    mnesia:create_table(cost,[{attributes,record_info(fields,cost)}]),
    %% 创建design表
    mnesia:create_table(design,[{attributes,record_info(fields,design)}]),
    %% 关闭数据库
    mnesia:stop().

reset_table() ->
    mnesia:clear_table(shop),
    mnesia:clear_table(cost),
    F = fun() -> 
        lists:foreach(fun mnesia:write/1,example_tables())
        end,
        mnesia:transaction(F).

%% 测试数据
example_tables() ->
    [
        %% shop table
        {shop,apple,20,2.3},
        {shop,orange,100,3.8},
        {shop,pear,200,3.6},
        {shop,banana,420,4.5},
        {shop,potato,2456,1.2},
        %% cost table
        {cost,apple,1.5},
        {cost,orange,2.4},
        {cost,pear,2.2},
        {cost,banana,1.6},
        {cost,potato,0.6}
    ].

start() ->
    mnesia:start(),
    %% 等待表的加载
    mnesia:wait_for_table([shop,cost,design],20000).

%% 定义和插入数据
insert(Reco) ->  
    mnesia:transaction(fun() -> mnesia:write(Reco) end). 

insert_recos([]) -> ok;  
insert_recos([H|T]) ->  
    insert(H),  
    insert_recos(T).

myinsert() ->  
    Todolst = [#todo{},#todo{status=done},#todo{who="zyf"},#todo{text="abcccc"}],  
    insert_recos(Todolst).  

%%删除表中的数据
delete_reco(Item) ->  
    F = fun() -> mnesia:delete({todo,Item}) end,  
    mnesia:transaction(F).  

%%定义数据查询工具函数  
query(Q) ->  
    F = fun() ->qlc:e(Q) end,  
    {atomic,Val} = mnesia:transaction(F),  
    Val.  

%% 定义查询表中所有数据记录  
queryall() ->  
   query(qlc:q([X || X <- mnesia:table(todo)])). 





