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
  member( Goal, State),
  satisfied( State, Goals).

select( State, Goals, Goal)  :-
  member( Goal, Goals),
  not member( Goal, State).                % Goal not satisfied already

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

