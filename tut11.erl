-module(tut11).

-export([month_length/2]).

month_length(Year,Month) ->
	%% 被 400 整除的为闰年。
    %% 被 100 整除但不能被 400 整除的不是闰年。
    %% 被 4 整除但不能被 100 整除的为闰年。
	Leap = if 
		trunc(Year / 400) * 400 == Year ->
		%Year取整除400 再乘400 等于Year，说明能被400整除
			leap;
		trunc(Year / 100) * 100 == Year ->
			not_leap;
		trunc(Year / 4) * 4 == Year ->
			leap;
		true ->
			not_leap
	end,

	case Month of
		apr -> 30;%四月
		jun -> 30;%六月
		sept -> 30;%九月
		nov -> 30;%十一月
		feb when Leap == leap -> 29;%闰年二月
		feb -> 28;%平年二月
		jan -> 31;%一月
		mar -> 31;%三月
		may -> 31;%五月
		jul -> 31;%七月
		aug -> 31;%八月
		oct -> 31;
		%十月
		dec -> 31
		%十二月
	end.