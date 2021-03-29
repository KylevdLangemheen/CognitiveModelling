;;; Miner act-r model
;;;

(add-dm
    (ATTACK1 isa move player one role saboteur action attack)
;;    (ATTACK2 isa move player two role saboteur action attack)
;;    (ATTACK3 isa move player three role saboteur action attack)

    (HELP1 isa move player one role miner action help)
;;    (HELP2 isa move player two role miner action help)
;;    (HELP3 isa move player three role miner action help)

;;    (NEUTRAL isa genericmove player any role unknown action play)
    (NEUTRAL1 isa move player one role unknown action play)
;;    (NEUTRAL2 isa genericmove player two role unknown action play)
;;    (NEUTRAL3 isa genericmove player three role unknown action play)

    (r1 isa rimplication role unknown implication unknown)
    (r2 isa rimplication role miner implication saboteur)
    (r3 isa rimplication role saboteur implication miner)

    (s0 isa restimate player zero role saboteur)
    (m0 isa restimate player zero role miner)
    (n0 isa restimate player zero role unknown)
    (s1 isa restimate player one role saboteur)
    (m1 isa restimate player one role miner)
    (n1 isa restimate player one role unknown)
;;    (s2 isa restimate player two role saboteur)
;;    (m2 isa restimate player two role miner)
;;    (n2 isa restimate player two role unknown)
;;    (s3 isa restimate player three role saboteur)
;;    (m3 isa restimate player three role miner)
;;    (n3 isa restimate player three role unknown)
    (goal isa goal state start)
)

(set-all-baselevels -100 10) ;; time offset and number of references
;; Prefer 'unknown' restimates?

;; At the start of the model, retrieve miner decision







(p prepare-for-action-start
    =goal>
        isa goal
        state start
==>
    =goal>
        state waiting
    +action>
        isa process
)

(p retrieve-player-belief
    =goal>
        isa goal
        state waiting
    =action>
        isa process
        playerno =p
==>
    =goal>
        state retrieving-belief
    +retrieval>
        isa restimate
        player =p
    -imaginal>
    -action>
)

(p return-player-belief
    =goal>
        isa goal
        state retrieving-belief
    =retrieval>
        isa restimate
        role =r
==>
    =goal>
        state returned-belief
    +action
        isa process
        role =r
)

(p restart-after-returning
    =goal>
        isa goal
        state returned-belief
==>
    +goal>
        isa goal
        state start
    -action>
)






(p retrieve-decision-start
   =goal>
     isa goal
     state start
==>
   =goal>
     state make-move
   +retrieval>
     isa move
   -imaginal>
)

(p make-move
    =goal>
        isa goal
        state make-move
    =retrieval>
        isa move
        action =decision
        player =playerno
==>
    =goal>
        state decide
    +action>
        isa move
        choice =decision
        player =playerno
)

(p restart-after-action
  =goal>
    isa goal
    state start
==>
  +goal>
     isa goal
     state start
)

(p update-role-beliefs
  =goal>
    isa goal
    state update-role
  =action>
    isa restimate
    player =playerno
    role =evidence
==>
  +goal>
    isa goal
    state update-role-next
  +imaginal>
    isa restimate
    player =playerno
    role =evidence
)

(p estimate-role-beliefs
  =goal>
    isa goal
    state estimate-role
  =action>
    isa restimate
    player =playerno
    role =evidence
==>
  +goal>
    isa goal
    state estimate-role-beliefs
    player =playerno
    role =evidence
  +retrieval>
    isa rimplication
    role =evidence
)

(p estimate-update-role-beliefs
  =goal>
    isa goal
    state estimate-role-beliefs
    player =playerno
    role =evidence
  =retrieval>
    isa rimplication
    implication =estimate
==>
  +goal
    isa goal
    state estimate-role-beliefs-next
  +imaginal>
    isa restimate
    player =playerno
    role =estimate
)

(goal-focus goal)
