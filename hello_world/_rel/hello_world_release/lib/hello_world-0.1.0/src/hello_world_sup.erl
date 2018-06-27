-module(hello_world_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->

%% 重启策略是 one_for_one
  %% 重启频率是5 秒内最多重启1次，如果超过这个频率就不再重启 映射
  SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},

  %% 只启动一个子进程，类型是 worker
  Procs = [#{id => hello_world,   %%  给子进程设置一个名字，supervisor 用这个名字标识这个进程。
              start => {hello_world, start_link, []}, %% 启动时调用的 Module:Function(Args)
              restart => permanent,  %% 永远需要重启
              shutdown => brutal_kill, %% 关闭时不需要等待，直接强行杀死进程
              type => worker,
              modules => [cg3]}],  %% 使用的 Modules
  {ok, {SupFlags, Procs}}.



  % Procs = [],
  % {ok, {{one_for_one, 1, 5}, Procs}}.
