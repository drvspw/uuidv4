%%-------------------------------------------------------------------------------------------
%% Copyright (c) 2021 Venkatakumar Srinivasan
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% @author Venkatakumar Srinivasan
%% @since February 13, 2021
%%
%%-------------------------------------------------------------------------------------------
-module(uuidv4).

%% API exports
-export([
         new/0,
         to_string/1,
         to_binary/1
]).

-type uuid() :: binary().

-export_type([
              uuid/0
]).


-define(VERSION, 4).
-define(VARIANT, 2#10).

%%====================================================================
%% API functions
%%====================================================================
-spec new() -> uuid().
%% @doc Generate a v4 UUID (random) binary
new() ->
  <<U0:32, U1:16, _:4, U2:12, _:2, U3:30, U4:32>> = crypto:strong_rand_bytes(16),
  <<U0:32, U1:16, ?VERSION:4, U2:12, ?VARIANT:2, U3:30, U4:32>>.

-spec to_binary(UuidStr :: string()) -> uuid().
%% @doc Convert a UUID string to binary
to_binary(UuidStr) when is_list(UuidStr) ->
  HexParts = string:tokens(UuidStr, "$-"),
  [I0, I1, I2, I3, I4] = [int(Hex) || Hex <- HexParts],
  <<I0:32, I1:16, I2:16, I3:16, I4:48>>;

to_binary(_) ->
  erlang:error(badarg).

-spec to_string(UUID :: uuid()) -> string().
%% @doc Convert binary UUID to a string
to_string(<<U0:32, U1:16, U2:16, U3:16, U4:48>>) ->
  lists:flatten(io_lib:format("~8.16.0b-~4.16.0b-~4.16.0b-~4.16.0b-~12.16.0b", [U0, U1, U2, U3, U4]));

to_string(_) ->
  erlang:error(badarg).

%%====================================================================
%% Internal functions
%%====================================================================
int(Hex) ->
  {ok, [I], []} = io_lib:fread("~16u", Hex),
  I.


%%=========================================================================
%% Unit Test Suite
%%=========================================================================
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

suite_test_() ->
  UUID = uuidv4:new(),
  Str = uuidv4:to_string(UUID),
  [
    ?_assertEqual(16, size(UUID)),
    ?_assertEqual(36, length(Str)),
    ?_assertEqual(UUID, uuidv4:to_binary(Str))
  ].

-endif.
