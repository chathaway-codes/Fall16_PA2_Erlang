-module(main).
-compile(export_all).

%Use the following function to get a random node (or the current node if no named nodes exist).
get_random_node() ->
  World = net_adm:world(),
  case length(World) of
    0 -> node();
    _ -> rget_random_node(rand:uniform(length(World)), World)
  end.

rget_random_node(_, []) -> node();
rget_random_node(1, [H|_]) -> H;
rget_random_node(_, [H|[]]) -> H;
rget_random_node(N, [_|T]) -> rget_random_node(N-1, T).

do_work(StartSeq, TargetSeq, PID) ->
  PID ! {ok, 4}.

wait_for_done() ->
  receive
    {ok, Result} -> io:fwrite("~B~n", [Result])
  end.

start() ->
  {ok, [StartSequence]} = io:fread("", "~s"),
  {ok, [TargetSequence]} = io:fread("", "~s"),
  spawn(main, do_work, [StartSequence, TargetSequence, self()]),
  wait_for_done().

