%   Figure 17.5  A simple means-ends planner.

%   A simple means-ends planner
%   plan( State, Goals, Plan, FinalState)

plan( State, Goals, [], State)  :-                 % Plan is empty
  satisfied( State, Goals).                        % Goals true in State

%  The way plan is decomposed into stages by conc, the 
%  precondition plan (PrePlan) is found in breadth-first
%  fashion. However, the length of the rest of plan is not 
%  restricted and goals are achieved in depth-first style.

plan( State, Goals, Plan, FinalState)  :-
  conc( PrePlan, [Action | PostPlan], Plan),        % Divide plan
  select( State, Goals, Goal),                      % Select a goal
  achieves( Action, Goal),                          % Relevant action
  can( Action, Condition),
  plan( State, Condition, PrePlan, MidState1),      % Enable Action
  apply( MidState1, Action, MidState2),             % Apply Action
  plan( MidState2, Goals, PostPlan, FinalState).    % Achieve remaining goals

% satisfied( State, Goals): Goals are true in State

satisfied( State, []).

satisfied( State, [Goal | Goals])  :-
  member(Goal, State),
  satisfied( State, Goals).

% Satisfied instantiating clause 
% Look for an instantiation that satisfies list of goals in state
satisfied( State, [Goal | Goals])  :-
  instantiated_goal(Goal),
  member(Goal, State),
  satisfied( State, Goals).

% Satisfied clause for pseudo-goal 'different'
satisfied( State, [Goal | Goals])  :-
  holds(Goal),
  satisfied( State, Goals).

% Uninstantiated and do not match
holds(different(X, Y)) :-
  var(X),
  var(Y),
  X \== Y.

% Instantiated and different
holds(different(X, Y)) :-
  not(var(X)),
  not(var(Y)),
  not(X == Y).

% TODO: X and Y match but not literally the same => postpone until further instantiation
% holds(different(X, Y)) :-
%   var(X),
%   var(Y),
%   X \== Y.

select( State, Goals, Goal)  :-
  member( Goal, Goals),
  not( member( Goal, State)).                % Goal not satisfied already

% achieves( Action, Goal): Goal is add-list of Action

achieves( Action, Goal)  :-
  adds( Action, Goals),
  member( Goal, Goals).

% apply( State, Action, NewState): Action executed in State produces NewState

apply( State, Action, NewState)  :-
  deletes( Action, DelList),
  delete_all( State, DelList, State1), !,
  adds( Action, AddList),
  conc( AddList, State1, NewState).

%  delete_all( L1, L2, Diff) if Diff is set-difference of L1 and L2

delete_all( [], _, []).

delete_all( [X | L1], L2, Diff)  :-
  member( X, L2),  !,
  delete_all( L1, L2, Diff).

delete_all( [X | L1], L2, [X | Diff])  :-
  delete_all( L1, L2, Diff).

conc(L1, L2, L3) :- append(L1, L2, L3).
% conc([], L2, L2).
% conc([_|L1], L2, [_|L3) :-
%   conc(L1, L2, L3).

%  Figure 17.2  A definition of the planning space for the blocks world.
%  Note: For compatibility with Sicstus Prolog, predicate block/1 in Figure 17.2
%  is here replaced by is_block/1.

% Definition of action move( Block, From, To) in blocks world

% can( Action, Condition): Action possible if Condition true

can( move( Block, From, To), [ clear( Block), clear( To), on( Block, From), different(From, To), different(Block, From)] ).
  % :-
  % is_block( Block),      % Block to be moved
  % object( To),           % "To" is a block or a place
  % To \== Block,          % Block cannot bå moved to itself
  % object( From),         % "From" is a block or a place
  % From \== To,           % Move to new position
  % Block \== From.        % Block not moved from itself

instantiated_goal(clear(X)) :-
  var(X),
  is_block(X).

instantiated_goal(on(X, Y)) :-
  var(X), var(Y),
  is_block(X),
  object(Y).


% adds( Action, Relationships): Action establishes Relationships

adds( move(X,From,To), [ on(X,To), clear(From)]).

% deletes( Action, Relationships): Action destroys Relationships

deletes( move(X,From,To), [ on(X,From), clear(To)]).

object( X)  :-           % X is an objects if
  place( X)              % X is a place
  ;                      % or
  is_block( X).          % X is a block


% A blocks world

is_block( a).
is_block( b).
is_block( c).

place( 1).
place( 2).
place( 3).
place( 4).

%  A state in the blocks world
%
%         c
%         a b
%         ====
%  place  1234

state( [ clear(2), clear(4), clear(b), clear(c), on(a,1), on(b,3), on(c,a) ] ).
