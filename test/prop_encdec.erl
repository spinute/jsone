-module(prop_encdec).
-include_lib("proper/include/proper.hrl").

prop_test0() ->
    ?FORALL(In, term(),
            In == jsone:decode(jsone:encode(In))).

prop_test1() ->
    ?FORALL(In, ?SUCHTHAT(T, term(), jsonifiable(T)),
            In == jsone:decode(jsone:encode(In))).

prop_test2() ->
    ?FORALL(In, bijective(),
            In == jsone:decode(jsone:encode(In))).

jsonifiable(Term) ->
    case jsone:try_encode(Term) of
        {ok, _} -> true;
        _ -> false
    end.

% https://github.com/sile/jsone#data-mapping-erlang--json
bijective() ->
    oneof([?LAZY(map(string(), bijective())),
    %oneof([?LAZY(map(bijective(), bijective())),
           %?LAZY(loose_tuple(bijective())),
           ?LAZY(list(bijective())),
           bijective_unit()]).

bijective_unit() ->
    oneof([null, undefined, true, false, utf8(), integer(), float()]).

% encodable() -> ok.

% timestamp() ->
%     calendar:gregorian_seconds_to_datetime(non_neg_integer()).
