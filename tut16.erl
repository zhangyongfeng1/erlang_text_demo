-module(tut16).

-export([start/0,ping/1,pong/0]).

ping(0) ->
	pong ! finished,
	%发送信息
	io:format("ping finished~n",[]);

ping(N) ->
	pong ! {ping,self()},
	%发送信息，当前shell进程
	receive
		%接收消息并打印
		pong ->
			io:format("Ping received pong~n",[])
	end,
	ping(N - 1).

pong() ->
	receive
		finished ->
			%接收消息并打印
			io:format("pong finished~n",[]);
		{ping,Ping_PID} ->
			%接收消息并打印
			io:format("pong received ping~n",[]),
			Ping_PID ! pong,
			pong()
	end.

start() ->
	register(pong,spawn(tut16,pong,[])),
	%注册一个进程，命为pong
	spawn(tut16,ping,[3]).