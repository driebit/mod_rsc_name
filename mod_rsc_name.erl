%% Copyright 2014 Arjan Scherpenisse
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

%% @author Arjan Scherpenisse <arjan@miraclethings.nl>
%% @copyright 2014 Arjan Scherpenisse
%% @doc Automatic resource naming

-module(mod_rsc_name).
-author("Arjan Scherpenisse").

-mod_title("Unique resource names").
-mod_description("Assigns generated unique names for all resources").
-mod_prio(20).

-include_lib("zotonic.hrl").

-export([
         observe_rsc_update/3
        ]).


observe_rsc_update(#rsc_update{id=Id, props=AllProps}, {Changed, UpdateProps}, Context) ->
    case z_utils:is_empty(proplists:get_value(name, AllProps)) of
        true ->
            Title = z_trans:trans(proplists:get_value(title, UpdateProps ++ AllProps), Context),
            Name = calculate_name(Id, 0, Title, Context),
            {true, [{name, Name} | proplists:delete(name, UpdateProps)]};
        false ->
            {Changed, UpdateProps}
    end.                


calculate_name(Id, Seq, Title, Context) ->
    Name = z_string:to_name(
             iolist_to_binary([Title, " ",
                               case Seq of 0 -> []; _ -> integer_to_list(Seq) end
                              ])),
    case z_db:q1("SELECT id FROM rsc WHERE name = $1 AND id <> $2", [Name, Id], Context) of
        undefined ->
            Name;
        _ConflictId ->
            calculate_name(Id, Seq+1, Title, Context)
    end.
