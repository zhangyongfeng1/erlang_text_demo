-module(tut2).
-export([convert/2]).

%完成英寸与厘米之间的相互转换
%完成厘米转为英寸
convert(M,inch) ->
	M / 2.54;

%%完成英寸转为厘米
convert(M, centimeter) ->
	M * 2.54.