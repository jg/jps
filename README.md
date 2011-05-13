Run with (w/ trace):

    ?- [planer, world].
    ?- trace.
    ?- plan(state1, [on(a,b)], Plan, FinState).
    ?- notrace.

state1 is:

    %  A state in the blocks world
    %
    %         c
    %         a b
    %         ====
    %  place  1234

    state1( [ clear(2), clear(4), clear(b), clear(c), on(a,1), on(b,3), on(c,a) ] ).

