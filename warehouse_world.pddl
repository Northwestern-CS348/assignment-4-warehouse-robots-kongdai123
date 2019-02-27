(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action takeStuff
      :parameters (?r - robot ?l - location ?p - pallette)
      :precondition (and (free ?r) (at ?r ?l) (at ?p ?l))
      :effect (and (has ?r ?p) (not (free ?r)))
   )
   
   
   (:action moveFree
      :parameters (?r - robot ?l1 - location ?l2 - location)
      :precondition (and (free ?r) (at ?r ?l1) (connected ?l1 ?l2) (no-robot ?l2))
      :effect (and (at ?r ?l2) (not(at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)))
   )
   
   (:action moveStuff
      :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
      :precondition (and (has ?r ?p) (at ?r ?l1) (connected ?l1 ?l2) (no-pallette ?l2) (no-robot ?l2))
      :effect (and (at ?r ?l2) (not(at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)) 
      (at ?p ?l2) (not(at ?p ?l1)) (no-pallette ?l1) (not (no-pallette ?l2)))
   )
   
   
   (:action unPack
      :parameters (?s - shipment ?r - robot ?l - location ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) 
      (has ?r ?p) (packing-at ?s ?l) (at ?r ?l) (contains ?p ?si) (orders ?o ?si))
      :effect (and (free ?r) (not (has ?r ?p)) (not (orders ?o ?si)) (not (contains ?p ?si))  (includes ?s ?si) )
   
   )
   
   (:action removeP
      :parameters(?p - pallette ?si - saleitem ?l - location)
      :precondition (and (at ?p ?l) (not (contains ?p ?si)) )
      :effect (and (not (at ?p ?l)) (no-pallette ?l))
   
   )
   
   (:action complete
      :parameters (?s - shipment ?o - order ?si - saleitem ?l - location)
      :precondition (and (ships ?s ?o) (not (orders ?o ?si)) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (started ?s)) (not (packing-at ?s ?l)) (available ?l) )
   
   )


)
