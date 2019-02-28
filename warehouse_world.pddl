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
   

   
   (:action moveFree
      :parameters (?r - robot ?l1 - location ?l2 - location)
      :precondition (and (at ?r ?l1) (connected ?l1 ?l2) (no-robot ?l2))
      :effect (and (at ?r ?l2) (not(at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)))
   )
   
   (:action moveStuff
      :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
      :precondition (and (at ?r ?l1) (at ?p ?l1) (connected ?l1 ?l2) (no-pallette ?l2) (no-robot ?l2))
      :effect (and (at ?r ?l2) (not(at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)) 
      (at ?p ?l2) (not(at ?p ?l1)) (no-pallette ?l1) (not (no-pallette ?l2)))
   )
   
   
   (:action unPack
      :parameters (?s - shipment ?l - location ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (not (complete ?s)) (at ?p ?l) (packing-at ?s ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si))
      :effect (and (not (contains ?p ?si))  (includes ?s ?si) )
   )
  
   
   (:action complete
      :parameters (?s - shipment ?o - order ?si - saleitem ?l - location)
      :precondition (and (ships ?s ?o) (not (complete ?s)) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (started ?s)) (available ?l) )
   
   )


)
