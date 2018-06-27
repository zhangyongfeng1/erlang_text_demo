-module(file_change).
-export([process/2]).

%对文件进行处理
%将 xml报文格式的报文转为lua 去取值
%如由 <khxm><name>姓名</name><value>123</value></khxm> 转为 
%this.hqzhxx_ccsz_name = body['hqzhxx']["ccsz"]['name']  or "";--持仓市值

process(FileIn, FileOut)->
	{Status,Value} = file:open(FileIn,read),
	if Status =:= ok ->
			io:format("==== open successed ====!~n"),
			Tokens = readFile(Value),%%读取文件并处理
			io:format("file_value------~p ~n",[Tokens]),
			file:write_file("./"++FileOut,[Tokens]),%%写文件
			io:format("==== end ===!~n");
	   	Status =/= ok ->
			io:format("open file error!")
	end.
	
readFile(Value) ->
	readFile(Value,[]).

readFile(Value,ReturnList) ->
	OneLine = io:get_line(Value,""),%一行一行读取文件
	if 
		OneLine =:= eof -> %文件末尾标记 文件结束,关闭文件
			io:format("acrss the file end! ~n"),
			file:close(Value),
			ReturnList;
		OneLine =/= eof ->
			Tokens = string:tokens(OneLine,"< > /> \n"),% 使用多个分隔符把字符串分割

			Len = string:len(Tokens),%获取一个字符长度
			if  Len =:= 0 ->
					io:format(" end to read ~n"),
					file:close(Value),
					ReturnList;
				Len =/= 0 ->
					%对一行的数据进行处理
					io:format(" the line Value ~p~n",[OneLine]),
					%<khxm><name>姓名</name><value>123</value></khxm>
					%this.hqzhxx_ccsz_name = body['hqzhxx']["ccsz"]['name']  or "";--持仓市值
					%%取出列表对应个数的值
					Tokens_1 = lists:nth(1,Tokens),%
					Tokens_2 = lists:nth(2,Tokens),%name
					Tokens_3 = lists:nth(3,Tokens),%注解
					Tokens_5 = lists:nth(5,Tokens),%value

					%对字符串进行拼接
					BB = "this." ++ Tokens_1 ++ "_" ++ Tokens_2,
					BB2 = "this." ++ Tokens_1 ++ "_" ++ Tokens_5,
					CC  = "body['" ++ Tokens_1 ++"']['" ++Tokens_2++ "']",
					CC2  = "body['" ++ Tokens_1 ++"']['" ++Tokens_5++ "']",
					DD = " or '';--" ++Tokens_3,
					EE = BB ++ " = " ++ CC ++ DD ++ "\n",
					EE2 = BB2 ++ " = " ++ CC2 ++ DD ++ "\n",

					GG =string:concat(EE,EE2),%将两个字符串列表拼接

					% io:format(" the line Value BB ~p~n",[BB]),
					% io:format(" the line Value BB2 ~p~n",[BB2]),
					% io:format(" the line Value CC ~p~n",[CC]),
					% io:format(" the line Value CC2 ~p~n",[CC2]),
					% io:format(" the line Value DD ~p~n",[DD]),
					% io:format(" the line Value EE ~p~n",[EE]),
					% io:format(" the line Value EE2 ~p~n",[EE2]),
					NewDic = string:concat(ReturnList,GG),
					readFile(Value,NewDic)
			end
	end.


