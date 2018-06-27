-module(tut15).

-export([start/0,
	ping/2,
	pong/0]).

ping(0,Pong_PID) ->
	Pong_PID ! finished,
	%向传过来的PID发送消息
	io:format("ping finished~n",[]);

ping(N,Pong_PID) ->
	Pong_PID ! {ping,self()},
	%向传过来的PID发送消息
	receive
		%%接收到传过来的消息,收到的消息为pong时，输入内容
		pong ->
			io:format("ping recevied pong~n",[])
	end,
	%重复调用，直到为N-1 为0
	ping(N - 1,Pong_PID).
		
pong() ->
	receive 
		finished -> %收到的消息为finished 时输入内容
			io:format("Pong finish ~n",[]);
		{ping,Ping_PID} ->
			io:format("Pong received ping~n",[]),
			Ping_PID ! pong,
			%向传过来的PID发送消息
			pong()%%自已调用自已，直到接收到finished，结束
	end.
	
start() ->
	Pong_PID = spawn(tut15, pong, []),
	spawn(tut15, ping, [3, Pong_PID]).
