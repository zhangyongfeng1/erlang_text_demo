-module(color).

-export([new/4,blend/2]).

-define(is_channel(V) ,
		(is_float(V) andalso V > 0.0 andalso V =< 1.0)
		).

%%接收一个新的alpha 颜色的值并添加返回到映射里面
new(R, G, B, A) when ?is_channel(R),?is_channel(G),
					?is_channel(B),?is_channel(A) ->
	#{red => R, green => G, blue => B, alpha => A}.

alpha(#{alpha := SA},#{alpha := DA}) ->
    SA + DA * (1.0 - SA).

red() ->

ok.

green() ->
ok.

blue() ->
ok.


blend(Src, Dst) ->
    blend(Src, Dst, alpha(Src,Dst)).



blend(_A,_B)->
    ok.

		
